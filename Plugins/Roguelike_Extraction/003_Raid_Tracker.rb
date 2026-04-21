#===============================================================================
# Raid Tracker & Extraction System
#===============================================================================
# Handles Bag Snapshotting, Blackouts, Extractions, and Floor Progression.
#===============================================================================

# Add variables to PokemonGlobalMetadata to persist across saves
class PokemonGlobalMetadata
  attr_writer :current_raid_floor
  attr_writer :last_raid_floor
  attr_writer :raid_bag_snapshot
  attr_writer :secure_pouch_items
  attr_writer :secure_pouch_capacity

  alias roguelike_extraction_init initialize unless private_method_defined?(:roguelike_extraction_init)
  def initialize
    roguelike_extraction_init
    @current_raid_floor = 0
    @last_raid_floor = 0
    @raid_bag_snapshot = nil
    @secure_pouch_items = []
    @secure_pouch_capacity = RoguelikeExtraction::SECURE_POUCH_START_CAPACITY
  end

  # Lazy Initialization getters.
  # This prevents crashes (like `undefined method '+' for nil:NilClass`)
  # when the player loads a save file created *before* this script was added.
  def current_raid_floor
    @current_raid_floor ||= 0
    return @current_raid_floor
  end

  def last_raid_floor
    @last_raid_floor ||= 0
    return @last_raid_floor
  end

  def raid_bag_snapshot
    return @raid_bag_snapshot
  end

  def secure_pouch_items
    @secure_pouch_items ||= []
    return @secure_pouch_items
  end

  def secure_pouch_capacity
    @secure_pouch_capacity ||= RoguelikeExtraction::SECURE_POUCH_START_CAPACITY
    return @secure_pouch_capacity
  end
end

module RoguelikeExtraction
  # Configuration for the raid progression

  # The Hub location where the player returns after an extract or blackout
  HUB_LOCATION = [77, 20, 14, 6] # Map ID 77 (where Steven is), X, Y

  #-----------------------------------------------------------------------------
  # Bag Snapshot Logic
  #-----------------------------------------------------------------------------

  # Takes a snapshot of the player's current bag, excluding Key Items.
  # Key Items are considered permanent unlocks and are never lost on blackout.
  def self.snapshot_bag
    return if !$PokemonBag

    snapshot = {}

    # Mobile Optimization: Iterate ONLY the active pockets and items
    # instead of scanning the entire GameData::Item database (O(N) vs O(1000+)).
    $PokemonBag.pockets.each_with_index do |pocket, pocket_idx|
      next if pocket.empty?
      pocket.each do |item_entry|
        item_id = item_entry[0]
        qty = item_entry[1]

        # Pocket 8 is typically Key Items, but we explicitly verify via GameData
        item_data = GameData::Item.try_get(item_id)
        if item_data && !item_data.is_key_item? && qty > 0
          snapshot[item_id] = qty
        end
      end
    end

    $PokemonGlobal.raid_bag_snapshot = snapshot
  end

  # Reverts the player's bag to the snapshot taken at the start of the current floor.
  # This deletes any non-key items acquired during the failed floor run.
  def self.revert_bag_to_snapshot
    return if !$PokemonBag || !$PokemonGlobal.raid_bag_snapshot

    # Clone the snapshot and immediately clear the global variable.
    # This temporarily disables the `remove` alias from modifying
    # the snapshot while we are actively trying to clear the player's bag.
    safe_snapshot = $PokemonGlobal.raid_bag_snapshot.clone
    $PokemonGlobal.raid_bag_snapshot = nil

    # 1. Clear all non-key items from the current bag
    $PokemonBag.pockets.each_with_index do |pocket, pocket_idx|
      next if pocket.empty?

      # Iterate in reverse because remove alters the array during iteration
      (0...pocket.length).to_a.reverse.each do |i|
        item_id = pocket[i][0]
        qty = pocket[i][1]

        item_data = GameData::Item.try_get(item_id)
        if item_data && !item_data.is_key_item? && qty > 0
          $PokemonBag.remove(item_id, qty)
        end
      end
    end

    # 2. Restore the non-key items from the safe snapshot
    safe_snapshot.each do |item_id, qty|
      $PokemonBag.add(item_id, qty)
    end
  end

  # Hardcore wipe: Completely deletes all non-key items from the bag.
  def self.wipe_bag_hardcore
    return if !$PokemonBag

    $PokemonGlobal.raid_bag_snapshot = nil

    $PokemonBag.pockets.each_with_index do |pocket, pocket_idx|
      next if pocket.empty?

      (0...pocket.length).to_a.reverse.each do |i|
        item_id = pocket[i][0]
        qty = pocket[i][1]

        item_data = GameData::Item.try_get(item_id)
        if item_data && !item_data.is_key_item? && qty > 0
          $PokemonBag.remove(item_id, qty)
        end
      end
    end
  end

  # Hardcore wipe: Soft-Resets the player's Pokemon Party and PC.
  def self.wipe_pokemon_hardcore
    return if !$player || !$PokemonStorage

    # 1. Any remaining Pokémon in the party (e.g. wiped by a non-battle script or poison tick)
    # are permanently moved to the Graveyard box.
    graveyard_box_index = $PokemonStorage.maxBoxes - 1

    party_size = $player.party.length
    (0...party_size).to_a.reverse.each do |i|
      pkmn = $player.party[i]
      if pkmn
        # Store in graveyard with full spillover logic to prevent accidental deletion
        box_to_put = graveyard_box_index
        placed = false

        while box_to_put >= 0
          $PokemonStorage[box_to_put].length.times do |slot|
            if $PokemonStorage[box_to_put][slot].nil?
              $PokemonStorage[box_to_put][slot] = pkmn

              if $PokemonStorage[box_to_put].name.empty? || $PokemonStorage[box_to_put].name.start_with?("Box")
                 $PokemonStorage[box_to_put].name = "Graveyard"
              end

              placed = true
              break
            end
          end
          break if placed
          box_to_put -= 1
        end

        $player.party.delete_at(i)
      end
    end

    $player.party.compact!

    # 2. Search all PC boxes (excluding any box named "Graveyard") for a valid replacement Pokémon.
    valid_pc_pokemon = []

    ($PokemonStorage.maxBoxes).times do |box_idx|
      next if $PokemonStorage[box_idx].name == "Graveyard"

      $PokemonStorage[box_idx].length.times do |slot|
        pkmn = $PokemonStorage[box_idx][slot]
        if pkmn && !pkmn.egg?
          valid_pc_pokemon.push({ box: box_idx, slot: slot, pokemon: pkmn })
        end
      end
    end

    # 3. Handle Replacement or Soft-Reset Switch
    if valid_pc_pokemon.empty?
      # The player is completely out of Pokémon.
      $game_switches[RoguelikeExtraction::RAID_BLACKOUT_SWITCH] = true
      pbMessage(_INTL("HARDCORE BLACKOUT! Your entire party and PC have been wiped. Speak to Steven to start over..."))
    else
      # Randomly select one Pokémon from the PC to save the run
      chosen = valid_pc_pokemon.sample
      $player.party.push(chosen[:pokemon])
      $PokemonStorage[chosen[:box]][chosen[:slot]] = nil # Remove it from the PC

      $game_switches[RoguelikeExtraction::RAID_BLACKOUT_SWITCH] = false
      pbMessage(_INTL("HARDCORE BLACKOUT! Your party was wiped, but {1} was randomly summoned from your PC to save you!", chosen[:pokemon].name))
    end
  end

  #-----------------------------------------------------------------------------
  # Event State Management
  #-----------------------------------------------------------------------------

  # Resets all self-switches (A, B, C, D) for the given map ID.
  # This ensures trainers, chests, and VIPs are ready for a new run.
  def self.reset_map_events(map_id)
    return if !$game_self_switches

    # Iterate over all stored self-switches and clear any belonging to this map
    # $game_self_switches is a wrapper class, we must access the underlying hash data
    data_hash = $game_self_switches.instance_variable_get(:@data)
    if data_hash
      data_hash.keys.each do |key|
        # In RPG Maker XP, the key is an array: [map_id, event_id, "switch_name"]
        if key.is_a?(Array) && key[0] == map_id
          $game_self_switches[key] = false
        end
      end
    end

    # If the map is currently loaded, ensure events on it get their sprites updated
    if $game_map && $game_map.map_id == map_id && $game_map.events
      $game_map.events.values.each do |event|
        event.refresh if event.respond_to?(:refresh)
      end
    end
  end

  def self.reset_all_raid_maps
    # Loop over the unique map IDs defined in RAID_FLOORS
    RAID_FLOORS.map { |floor_data| floor_data[0] }.uniq.each do |map_id|
      reset_map_events(map_id)
    end
  end

  #-----------------------------------------------------------------------------
  # Raid Progression Logic
  #-----------------------------------------------------------------------------

  # Starts a new raid from Floor 1
  def self.start_raid
    snapshot_bag
    $game_system.save_disabled = true # Prevent mid-raid save-scumming
    $PokemonGlobal.current_raid_floor = 1

    # Reset raid states for the new run
    $PokemonGlobal.encounter_version = 0
    if $PokemonGlobal.instance_variable_defined?(:@fought_raid_trainers)
      $PokemonGlobal.instance_variable_set(:@fought_raid_trainers, [])
    end
    if $PokemonGlobal.instance_variable_defined?(:@raid_event_trainers)
      $PokemonGlobal.instance_variable_set(:@raid_event_trainers, {})
    end

    transfer_to_current_floor
  end

  # Advances the player to the next floor
  def self.advance_floor
    if $PokemonGlobal.current_raid_floor == 0
      start_raid
    else
      # Clear fought trainers when advancing to a new floor
      if $PokemonGlobal.instance_variable_defined?(:@fought_raid_trainers)
        $PokemonGlobal.instance_variable_set(:@fought_raid_trainers, [])
      end
      if $PokemonGlobal.instance_variable_defined?(:@raid_event_trainers)
        $PokemonGlobal.instance_variable_set(:@raid_event_trainers, {})
      end
      $PokemonGlobal.current_raid_floor += 1

      # Update encounter version based on floor tier (e.g. F1-4 = v0, F5-8 = v1, F9+ = v2)
      # This natively scales wild encounters.
      tier = ($PokemonGlobal.current_raid_floor - 1) / 4
      # Cap the version at 2 assuming we define 3 tiers of encounters in PBS
      $PokemonGlobal.encounter_version = [tier, 2].min

      # Standard Mode: Create a new snapshot checkpoint at the start of each new floor.
      snapshot_bag
      transfer_to_current_floor
    end
  end

  # The "Smart" function for Steven (Challenge Guide)
  # If the player isn't in a raid, it starts one.
  # If they are, it resumes their progress on the exact floor they left off.
  def self.resume_or_start_raid
    if $PokemonGlobal.current_raid_floor == 0
      start_raid
    else
      if pbConfirmMessage(_INTL("You are currently on Floor {1}. Continue deeper into the raid?", $PokemonGlobal.current_raid_floor))
        snapshot_bag
        $game_system.save_disabled = true # Re-disable mid-raid saving
        transfer_to_current_floor
      end
    end
  end

  def self.clear_procedural_state
    return unless $PokemonGlobal

    # 1. Reset standard procedural flags
    $PokemonGlobal.instance_variable_set(:@is_active_rift, false)
    $PokemonGlobal.instance_variable_set(:@dungeon_area, :none)

    # 2. Clear Rift specific variables
    $PokemonGlobal.instance_variable_set(:@current_rift_bounty, nil)
    $PokemonGlobal.instance_variable_set(:@current_rift_manifest, nil)
    $PokemonGlobal.instance_variable_set(:@rift_weather_types, nil)

    # 3. Reset screen weather and tone to default
    $game_screen.weather(:None, 0, 0) if $game_screen
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 0) if $game_screen
  end

  # Extracts via the VIP, securing loot but keeping the player's current floor progress.
  # This allows them to resume from the *next* floor later.
  def self.extract_vip
    clear_procedural_state

    $PokemonGlobal.raid_bag_snapshot = nil # Clear the snapshot, loot is secured
    $game_system.save_disabled = false     # Re-enable saving

    # We clear the map events for the CURRENT floor only, so when they
    # re-roll this map in endless mode later, it is fresh.
    if $game_map
      reset_map_events($game_map.map_id)
    end

    # The VIP signifies the end of the current floor.
    # To properly resume later via `resume_or_start_raid`, we need to
    # officially log that they *completed* this floor.
    # We advance the floor number here but do not transfer them yet.
    if $PokemonGlobal.instance_variable_defined?(:@fought_raid_trainers)
      $PokemonGlobal.instance_variable_set(:@fought_raid_trainers, [])
    end
    if $PokemonGlobal.instance_variable_defined?(:@raid_event_trainers)
      $PokemonGlobal.instance_variable_set(:@raid_event_trainers, {})
    end
    $PokemonGlobal.current_raid_floor += 1

    tier = ($PokemonGlobal.current_raid_floor - 1) / 4
    $PokemonGlobal.encounter_version = [tier, 2].min

    pbMessage(_INTL("VIP defeated! Extraction successful. Your loot has been secured, and your progress saved."))

    # Teleport to Hub
    $game_temp.player_transferring = true
    $game_temp.player_new_map_id = HUB_LOCATION[0]
    $game_temp.player_new_x = HUB_LOCATION[1]
    $game_temp.player_new_y = HUB_LOCATION[2]
    $game_temp.player_new_direction = 2
  end

  # Successfully leaves the raid, keeping all loot.
  def self.extract
    clear_procedural_state

    $PokemonGlobal.last_raid_floor = $PokemonGlobal.current_raid_floor
    $PokemonGlobal.current_raid_floor = 0
    $PokemonGlobal.raid_bag_snapshot = nil # Clear the snapshot, loot is secured
    $game_system.save_disabled = false     # Re-enable saving

    # Completely reset all maps so the next run starts fresh
    reset_all_raid_maps

    pbMessage(_INTL("Extraction successful! Your loot has been secured."))

    # Teleport to Hub
    $game_temp.player_transferring = true
    $game_temp.player_new_map_id = HUB_LOCATION[0]
    $game_temp.player_new_x = HUB_LOCATION[1]
    $game_temp.player_new_y = HUB_LOCATION[2]
    $game_temp.player_new_direction = 2
  end

  # Wipe Pokemon based on Standard/Easy mode.
  def self.wipe_pokemon_standard
    return if !$player || !$player.party || !$PokemonStorage

    # Identify the last box in the PC for Graveyard
    graveyard_box_index = $PokemonStorage.maxBoxes - 1

    easy_mode = $game_switches[105]

    # Find the starter
    starter_idx = -1
    $player.party.each_with_index do |pkmn, idx|
      if pkmn && pkmn.is_roguelike_starter
        starter_idx = idx
        break
      end
    end

    # In Easy Mode, randomly retain 1 other pokemon
    retained_idx = -1
    if easy_mode
      candidates_with_hp = []
      all_candidates = []

      $player.party.each_with_index do |pkmn, idx|
        if pkmn && idx != starter_idx && !pkmn.egg?
          all_candidates.push(idx)
          candidates_with_hp.push(idx) if pkmn.hp > 0
        end
      end

      if !candidates_with_hp.empty?
        retained_idx = candidates_with_hp.sample
      elsif !all_candidates.empty?
        retained_idx = all_candidates.sample
      end
    end

    # Iterate backwards through the party to remove and graveyard
    party_size = $player.party.length
    (0...party_size).to_a.reverse.each do |i|
      pkmn = $player.party[i]
      next if !pkmn

      if i == starter_idx || i == retained_idx
        # Retain and fully heal this pokemon (removes curses if any)
        pkmn.hp = pkmn.totalhp
        pkmn.status = :NONE
        pkmn.is_cursed = false
        pkmn.markings[3] = 0 # Remove Heart marking just in case
        next
      end

      # Send the rest to the graveyard
      # If Easy Mode is ON, apply cursed flag and Heart marking
      if easy_mode
        pkmn.is_cursed = true
        pkmn.markings[3] = 1
      end

      placed = false
      box_to_put = graveyard_box_index
      while box_to_put >= 0
        $PokemonStorage[box_to_put].length.times do |slot|
          if $PokemonStorage[box_to_put][slot].nil?
            $PokemonStorage[box_to_put][slot] = pkmn

            if $PokemonStorage[box_to_put].name.empty? || $PokemonStorage[box_to_put].name.start_with?("Box")
               $PokemonStorage[box_to_put].name = "Graveyard"
            end

            placed = true
            break
          end
        end
        break if placed
        box_to_put -= 1
      end

      # Remove from party
      $player.party.delete_at(i)
    end

    # Make sure party is compacted
    $player.party.compact!
  end

  # Fails the raid, penalizing the player based on the current Mode.
  def self.blackout
    clear_procedural_state

    $PokemonGlobal.last_raid_floor = $PokemonGlobal.current_raid_floor
    $PokemonGlobal.current_raid_floor = 0
    $PokemonGlobal.save_disabled = false if $PokemonGlobal.respond_to?(:save_disabled)
    $game_system.save_disabled = false # Re-enable saving

    # Completely reset all maps so the next run starts fresh
    reset_all_raid_maps

    # Check if Hardcore Mode is enabled
    if $game_switches[RoguelikeExtraction::HARDCORE_MODE_SWITCH]
      wipe_bag_hardcore
      wipe_pokemon_hardcore
    else
      revert_bag_to_snapshot
      wipe_pokemon_standard
      pbMessage(_INTL("You blacked out! The loot you found on this floor was lost..."))
    end

    # Teleport to Hub
    $game_temp.player_transferring = true
    $game_temp.player_new_map_id = HUB_LOCATION[0]
    $game_temp.player_new_x = HUB_LOCATION[1]
    $game_temp.player_new_y = HUB_LOCATION[2]
    $game_temp.player_new_direction = 6
  end

  # Internal helper to transfer the player based on the current floor
  def self.transfer_to_current_floor
    # 1. Determine a safe, unused Map ID dynamically (starting from 500 to preserve official maps)
    mapinfos_path = "Data/MapInfos.rxdata"
    begin
      mapinfos = load_data(mapinfos_path)
    rescue
      pbMessage(_INTL("Fatal Error: Could not load MapInfos.rxdata."))
      return
    end

    new_map_id = [500, (mapinfos.keys.max || 0) + 1].max

    # 2. Generate the regular floor on-the-fly
    if defined?(pbGenerateRegularFloor)
      success = pbGenerateRegularFloor(new_map_id)
      unless success
        pbMessage(_INTL("Failed to dynamically generate Floor {1}.", $PokemonGlobal.current_raid_floor))
        return
      end
    else
      pbMessage(_INTL("Procedural Generator is not loaded! Cannot build floor."))
      return
    end

    # 3. Transfer the player to the newly generated map
    $game_temp.player_transferring = true
    $game_temp.player_new_map_id = new_map_id
    $game_temp.player_new_x = 10  # Standard entry X coordinate from pbGenerateRegularFloor
    $game_temp.player_new_y = 10  # Standard entry Y coordinate
    $game_temp.player_new_direction = 2

    # Since we removed pbFadeOutIn to allow the engine's native transfer logic to process,
    # we need to schedule the mining spot generation to happen exactly after the map loads.
    # The safest way is to hook it into the on_game_map_setup handler in 009_Persistent_Artifacts.rb,
    # but for now we can just queue it dynamically.
    if defined?(pbSpawnFloorMiningSpots)
      # We must let the engine transfer the player first. The next frame's map setup will handle spawning.
      $PokemonGlobal.instance_variable_set(:@pending_mining_spawns, true)
    end
  end
end

#===============================================================================
# RPG Maker Event Script Call Helpers
#===============================================================================
# These shorter method names fit easily inside the strict RPG Maker XP
# Script Call box width limit without throwing NoMethodError line-breaks.
#===============================================================================

def pbStartRaid
  RoguelikeExtraction.resume_or_start_raid
end

def pbAdvanceRaid
  RoguelikeExtraction.advance_floor

  # --- BOUNTY HOOK: SURVIVOR ---
  if $PokemonGlobal.current_raid_floor >= 20 && $PokemonGlobal && $PokemonGlobal.quests.active_quests.any? { |q| q.id == :Quest3 }
    completeQuest(:Quest3)
    # We don't give the reward here, the player claims it at the board
  end
  # -----------------------------
end

def pbExtractRaid
  RoguelikeExtraction.extract
end

def pbExtractRaidVIP
  RoguelikeExtraction.extract_vip
end

def pbBlackoutRaid
  RoguelikeExtraction.blackout
end

def pbHealCursedPokemon
  return if !$player || !$player.party

  cursed_count = 0
  $player.party.each do |pkmn|
    cursed_count += 1 if pkmn && pkmn.is_cursed
  end

  if cursed_count == 0
    pbMessage(_INTL("You have no cursed Pokémon in your party."))
    return
  end

  floor_multiplier = [$PokemonGlobal.last_raid_floor, 1].max
  cost = 200 * cursed_count * floor_multiplier

  if pbConfirmMessage(_INTL("I can lift the curse and fully heal your {1} Pokémon for ${2}. Will you pay?", cursed_count, cost))
    if $player.money >= cost
      $player.money -= cost
      $player.party.each do |pkmn|
        if pkmn && pkmn.is_cursed
          pkmn.hp = pkmn.totalhp
          pkmn.status = :NONE
          pkmn.is_cursed = false
          pkmn.markings[3] = 0 # Remove Heart marking
        end
      end
      pbMessage(_INTL("The curse has been lifted, and your Pokémon are fully restored!"))
    else
      pbMessage(_INTL("You don't have enough money..."))
    end
  else
    pbMessage(_INTL("Come back if you change your mind."))
  end
end

#===============================================================================
# Dynamic Snapshot Syncing (Consumables)
#===============================================================================
# Hooks into the core Pokémon Bag to ensure that if a player consumes an item
# (e.g., uses a Potion) during a raid, it is permanently deducted from the
# start-of-floor snapshot so they cannot simply get it back by blacking out.
#===============================================================================

class PokemonBag
  alias roguelike_extraction_remove remove unless method_defined?(:roguelike_extraction_remove)

  def remove(item, qty = 1)
    # Perform the original item deletion
    result = roguelike_extraction_remove(item, qty)

    # If the deletion was successful, the player is currently in a raid,
    # and a valid snapshot exists, we must permanently deduct this item
    # from the snapshot so it isn't "refunded" on a blackout.
    if result && $PokemonGlobal && $PokemonGlobal.current_raid_floor.to_i > 0 && $PokemonGlobal.raid_bag_snapshot
      item_id = GameData::Item.get(item).id

      # We only care about non-Key items that were actually in the snapshot
      if $PokemonGlobal.raid_bag_snapshot.key?(item_id)
        $PokemonGlobal.raid_bag_snapshot[item_id] -= qty
        if $PokemonGlobal.raid_bag_snapshot[item_id] <= 0
          $PokemonGlobal.raid_bag_snapshot.delete(item_id)
        end
      end
    end

    return result
  end
end

#===============================================================================
# Overriding Default Game Over / Blackout Sequence
#===============================================================================
# In standard Pokémon Essentials, losing a battle triggers `pbStartOver`.
# `pbStartOver` automatically fully heals the player's party and teleports them
# to the last visited Pokémon Center.
# We intercept this globally: if the player is in an active raid, we block the
# default healing sequence entirely and trigger our custom extraction blackout.
#===============================================================================

alias roguelike_extraction_pbStartOver pbStartOver unless defined?(roguelike_extraction_pbStartOver)

def pbStartOver(*args)
  if $PokemonGlobal && $PokemonGlobal.current_raid_floor.to_i > 0
    # Player organically lost a battle mid-raid.
    # Block the default Pokémon Center heal entirely.
    RoguelikeExtraction.blackout
    return true # Returning true assumes the script handled the wipe sequence.
  else
    # Player is not in a raid, proceed with normal Essentials blackout behavior.
    return roguelike_extraction_pbStartOver(*args)
  end
end

def pbDefeatedVIP
  choice = pbMessage(_INTL("You defeated the VIP! Do you want to extract with your loot or continue?"), [
    _INTL("Continue"),
    _INTL("Extract")
  ], 1)

  if choice == 1
    pbExtractRaidVIP
  else
    pbMessage(_INTL("You chose to delve deeper. Good luck!"))
    pbAdvanceRaid
  end
end
