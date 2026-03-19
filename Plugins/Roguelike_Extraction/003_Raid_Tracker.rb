#===============================================================================
# Raid Tracker & Extraction System
#===============================================================================
# Handles Bag Snapshotting, Blackouts, Extractions, and Floor Progression.
#===============================================================================

# Add variables to PokemonGlobalMetadata to persist across saves
class PokemonGlobalMetadata
  attr_writer :current_raid_floor
  attr_writer :raid_bag_snapshot
  attr_writer :secure_pouch_items
  attr_writer :secure_pouch_capacity

  alias roguelike_extraction_init initialize
  def initialize
    roguelike_extraction_init
    @current_raid_floor = 0
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
  # Define the map IDs for each "floor" of the raid.
  # Format: Floor Number => [Map ID, X, Y]
  RAID_FLOORS = {
    1 => [78, 7, 10], # Example: Cavetia (from your screenshot)
    2 => [79, 10, 10],
    3 => [80, 10, 10],
    4 => [81, 10, 10]
  }

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
  # Raid Progression Logic
  #-----------------------------------------------------------------------------

  # Starts a new raid from Floor 1
  def self.start_raid
    snapshot_bag
    $game_system.save_disabled = true # Prevent mid-raid save-scumming
    $PokemonGlobal.current_raid_floor = 1
    transfer_to_current_floor
  end

  # Advances the player to the next floor
  def self.advance_floor
    if $PokemonGlobal.current_raid_floor == 0
      start_raid
    else
      $PokemonGlobal.current_raid_floor += 1
      if !RAID_FLOORS.key?($PokemonGlobal.current_raid_floor)
        # Reached the end of the raid! Treat as successful extraction.
        pbMessage(_INTL("You have conquered the final floor! Extracting..."))
        extract
      else
        # Standard Mode: Create a new snapshot checkpoint at the start of each new floor.
        snapshot_bag
        transfer_to_current_floor
      end
    end
  end

  # The "Smart" function for Steven (Challenge Guide)
  # If the player isn't in a raid, it starts one.
  # If they are, it advances them to the next floor.
  def self.resume_or_start_raid
    if $PokemonGlobal.current_raid_floor == 0
      start_raid
    else
      # Prompt the player if they want to continue their existing raid
      if pbConfirmMessage(_INTL("You are currently on Floor {1}. Continue deeper into the raid?", $PokemonGlobal.current_raid_floor))
        advance_floor
      end
    end
  end

  # Successfully leaves the raid, keeping all loot.
  def self.extract
    $PokemonGlobal.current_raid_floor = 0
    $PokemonGlobal.raid_bag_snapshot = nil # Clear the snapshot, loot is secured
    $game_system.save_disabled = false     # Re-enable saving
    pbMessage(_INTL("Extraction successful! Your loot has been secured."))

    # Teleport to Hub
    pbFadeOutIn do
      $game_temp.player_new_map_id = HUB_LOCATION[0]
      $game_temp.player_new_x = HUB_LOCATION[1]
      $game_temp.player_new_y = HUB_LOCATION[2]
      $game_temp.player_new_direction = 2
      $scene.transfer_player
    end
  end

  # Fails the raid, penalizing the player based on the current Mode.
  def self.blackout
    $PokemonGlobal.current_raid_floor = 0
    $game_system.save_disabled = false # Re-enable saving

    # Check if Hardcore Mode is enabled
    if $game_switches[RoguelikeExtraction::HARDCORE_MODE_SWITCH]
      wipe_bag_hardcore
      wipe_pokemon_hardcore
    else
      revert_bag_to_snapshot
      pbMessage(_INTL("You blacked out! The loot you found on this floor was lost..."))
    end

    # Teleport to Hub
    pbFadeOutIn do
      $game_temp.player_new_map_id = HUB_LOCATION[0]
      $game_temp.player_new_x = HUB_LOCATION[1]
      $game_temp.player_new_y = HUB_LOCATION[2]
      $game_temp.player_new_direction = 6
      $scene.transfer_player
    end
  end

  # Internal helper to transfer the player based on the current floor
  def self.transfer_to_current_floor
    floor_data = RAID_FLOORS[$PokemonGlobal.current_raid_floor]
    return if !floor_data

    map_id = floor_data[0]
    x = floor_data[1]
    y = floor_data[2]

    pbFadeOutIn do
      $game_temp.player_new_map_id = map_id
      $game_temp.player_new_x = x
      $game_temp.player_new_y = y
      $game_temp.player_new_direction = 2
      $scene.transfer_player
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
end

def pbExtractRaid
  RoguelikeExtraction.extract
end

def pbBlackoutRaid
  RoguelikeExtraction.blackout
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
