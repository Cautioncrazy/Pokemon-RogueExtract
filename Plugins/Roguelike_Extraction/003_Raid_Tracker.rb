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
  RAID_FLOORS = [
    [78, 7, 10], # Floor 1
    [79, 10, 10], # Floor 2
    [80, 10, 10], # Floor 3
    [81, 10, 10]  # Floor 4
  ]

  HUB_LOCATION = [77, 20, 14, 6] # Map ID 77 (where Steven is), X, Y

  def self.snapshot_bag
    return if !$PokemonBag

    snapshot = {}

    $PokemonBag.pockets.each_with_index do |pocket, pocket_idx|
      next if pocket.empty?
      pocket.each do |item_entry|
        item_id = item_entry[0]
        qty = item_entry[1]

        item_data = GameData::Item.try_get(item_id)
        if item_data && !item_data.is_key_item? && qty > 0
          snapshot[item_id] = qty
        end
      end
    end

    $PokemonGlobal.raid_bag_snapshot = snapshot
  end

  def self.revert_bag_to_snapshot
    return if !$PokemonBag || !$PokemonGlobal.raid_bag_snapshot

    safe_snapshot = $PokemonGlobal.raid_bag_snapshot.clone
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

    safe_snapshot.each do |item_id, qty|
      $PokemonBag.add(item_id, qty)
    end
  end

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

  def self.wipe_pokemon_hardcore
    return if !$player || !$PokemonStorage

    graveyard_box_index = $PokemonStorage.maxBoxes - 1

    party_size = $player.party.length
    (0...party_size).to_a.reverse.each do |i|
      pkmn = $player.party[i]
      if pkmn
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

    if valid_pc_pokemon.empty?
      $game_switches[RoguelikeExtraction::RAID_BLACKOUT_SWITCH] = true
      pbMessage(_INTL("HARDCORE BLACKOUT! Your entire party and PC have been wiped. Speak to Steven to start over..."))
    else
      chosen = valid_pc_pokemon.sample
      $player.party.push(chosen[:pokemon])
      $PokemonStorage[chosen[:box]][chosen[:slot]] = nil

      $game_switches[RoguelikeExtraction::RAID_BLACKOUT_SWITCH] = false
      pbMessage(_INTL("HARDCORE BLACKOUT! Your party was wiped, but {1} was randomly summoned from your PC to save you!", chosen[:pokemon].name))
    end
  end

  def self.wipe_pokemon_standard
    return if !$player || !$PokemonStorage

    graveyard_box_index = $PokemonStorage.maxBoxes - 1

    # Keep track of who we want to save
    saved_pokemon = []

    # Save the starter
    starter_idx = $player.party.index { |pkmn| pkmn && pkmn.respond_to?(:is_roguelike_starter) && pkmn.is_roguelike_starter }
    if starter_idx
      saved_pokemon.push($player.party[starter_idx])
    end

    # If Easy Mode (Switch 105) is ON, randomly save 1 more
    if $game_switches[105]
      available = $player.party.reject { |pkmn| saved_pokemon.include?(pkmn) }
      if !available.empty?
        saved_pokemon.push(available.sample)
      end
    end

    party_size = $player.party.length
    (0...party_size).to_a.reverse.each do |i|
      pkmn = $player.party[i]
      if pkmn
        # If this pokemon is not in our saved list, it goes to the graveyard
        if !saved_pokemon.include?(pkmn)
          box_to_put = graveyard_box_index
          placed = false

          while box_to_put >= 0
            $PokemonStorage[box_to_put].length.times do |slot|
              if $PokemonStorage[box_to_put][slot].nil?

                # Apply cursed mark for Easy Mode (Switch 105)
                if $game_switches[105]
                  pkmn.markings |= 8 # Heart marking
                  pkmn.is_cursed = true if pkmn.respond_to?(:is_cursed=)
                end

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
        else
          # Fully heal the saved pokemon so the player doesn't instantly blackout again
          pkmn.heal
        end
      end
    end

    $player.party.compact!
  end

  def self.reset_map_events(map_id)
    return if !$game_self_switches

    data_hash = $game_self_switches.instance_variable_get(:@data)
    if data_hash
      data_hash.keys.each do |key|
        if key.is_a?(Array) && key[0] == map_id
          $game_self_switches[key] = false
        end
      end
    end

    if $game_map && $game_map.map_id == map_id && $game_map.events
      $game_map.events.values.each do |event|
        event.refresh if event.respond_to?(:refresh)
      end
    end
  end

  def self.reset_all_raid_maps
    RAID_FLOORS.map { |floor_data| floor_data[0] }.uniq.each do |map_id|
      reset_map_events(map_id)
    end
  end

  def self.start_raid
    snapshot_bag
    $game_system.save_disabled = true
    $PokemonGlobal.current_raid_floor = 1

    $PokemonGlobal.encounter_version = 0
    if $PokemonGlobal.instance_variable_defined?(:@fought_raid_trainers)
      $PokemonGlobal.instance_variable_set(:@fought_raid_trainers, [])
    end
    if $PokemonGlobal.instance_variable_defined?(:@raid_event_trainers)
      $PokemonGlobal.instance_variable_set(:@raid_event_trainers, {})
    end

    transfer_to_current_floor
  end

  def self.advance_floor
    if $PokemonGlobal.current_raid_floor == 0
      start_raid
    else
      if $PokemonGlobal.instance_variable_defined?(:@fought_raid_trainers)
        $PokemonGlobal.instance_variable_set(:@fought_raid_trainers, [])
      end
      if $PokemonGlobal.instance_variable_defined?(:@raid_event_trainers)
        $PokemonGlobal.instance_variable_set(:@raid_event_trainers, {})
      end
      $PokemonGlobal.current_raid_floor += 1

      tier = ($PokemonGlobal.current_raid_floor - 1) / 4
      $PokemonGlobal.encounter_version = [tier, 2].min

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

  def self.extract_vip
    $PokemonGlobal.raid_bag_snapshot = nil
    $game_system.save_disabled = false

    if $game_map
      reset_map_events($game_map.map_id)
    end

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

    pbFadeOutIn do
      $game_temp.player_new_map_id = HUB_LOCATION[0]
      $game_temp.player_new_x = HUB_LOCATION[1]
      $game_temp.player_new_y = HUB_LOCATION[2]
      $game_temp.player_new_direction = 2
      $scene.transfer_player
    end
  end

  def self.extract
    $PokemonGlobal.last_raid_floor = $PokemonGlobal.current_raid_floor
    $PokemonGlobal.current_raid_floor = 0
    $PokemonGlobal.raid_bag_snapshot = nil
    $game_system.save_disabled = false

    reset_all_raid_maps

    pbMessage(_INTL("Extraction successful! Your loot has been secured."))

    pbFadeOutIn do
      $game_temp.player_new_map_id = HUB_LOCATION[0]
      $game_temp.player_new_x = HUB_LOCATION[1]
      $game_temp.player_new_y = HUB_LOCATION[2]
      $game_temp.player_new_direction = 2
      $scene.transfer_player
    end
  end

  def self.blackout
    $PokemonGlobal.last_raid_floor = $PokemonGlobal.current_raid_floor
    $PokemonGlobal.current_raid_floor = 0
    $game_system.save_disabled = false

    reset_all_raid_maps

    if $game_switches && defined?(RoguelikeExtraction::HARDCORE_MODE_SWITCH) && $game_switches[RoguelikeExtraction::HARDCORE_MODE_SWITCH]
      wipe_bag_hardcore
      wipe_pokemon_hardcore
    else
      revert_bag_to_snapshot
      wipe_pokemon_standard

      mode = $game_switches[105] ? "Easy Mode" : "Normal Mode"
      if $game_switches[105]
        pbMessage(_INTL("You blacked out! The loot you found on this floor was lost. Your starter and 1 other Pokémon survived the extraction, the rest were sent to the Graveyard cursed."))
      else
        pbMessage(_INTL("You blacked out! The loot you found on this floor was lost. Only your starter survived the extraction..."))
      end
    end

    pbFadeOutIn do
      $game_temp.player_new_map_id = HUB_LOCATION[0]
      $game_temp.player_new_x = HUB_LOCATION[1]
      $game_temp.player_new_y = HUB_LOCATION[2]
      $game_temp.player_new_direction = 6
      $scene.transfer_player
    end
  end

  def self.transfer_to_current_floor
    floor_index = $PokemonGlobal.current_raid_floor - 1
    floor_data = (floor_index < RAID_FLOORS.length) ? RAID_FLOORS[floor_index] : RAID_FLOORS.sample

    pbFadeOutIn do
      $game_temp.player_new_map_id = floor_data[0]
      $game_temp.player_new_x = floor_data[1]
      $game_temp.player_new_y = floor_data[2]
      $game_temp.player_new_direction = 2
      $scene.transfer_player
    end
  end
end

def pbStartRaid
  RoguelikeExtraction.resume_or_start_raid
end

def pbAdvanceRaid
  RoguelikeExtraction.advance_floor
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

class PokemonBag
  alias roguelike_extraction_remove remove unless method_defined?(:roguelike_extraction_remove)

  def remove(item, qty = 1)
    result = roguelike_extraction_remove(item, qty)

    if result && $PokemonGlobal && $PokemonGlobal.current_raid_floor.to_i > 0 && $PokemonGlobal.raid_bag_snapshot
      item_id = GameData::Item.get(item).id

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

alias roguelike_extraction_pbStartOver pbStartOver unless defined?(roguelike_extraction_pbStartOver)
def pbStartOver(*args)
  if $PokemonGlobal && $PokemonGlobal.current_raid_floor.to_i > 0
    RoguelikeExtraction.blackout
    return true
  else
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
