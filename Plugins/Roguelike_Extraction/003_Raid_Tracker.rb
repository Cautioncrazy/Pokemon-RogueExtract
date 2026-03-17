#===============================================================================
# Raid Tracker & Extraction System
#===============================================================================
# Handles Bag Snapshotting, Blackouts, Extractions, and Floor Progression.
#===============================================================================

# Add variables to PokemonGlobalMetadata to persist across saves
class PokemonGlobalMetadata
  attr_writer :current_raid_floor
  attr_writer :raid_bag_snapshot

  alias roguelike_extraction_init initialize
  def initialize
    roguelike_extraction_init
    @current_raid_floor = 0
    @raid_bag_snapshot = nil
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
  HUB_LOCATION = [77, 10, 10] # Map ID 77 (where Steven is), X, Y

  #-----------------------------------------------------------------------------
  # Bag Snapshot Logic
  #-----------------------------------------------------------------------------

  # Takes a snapshot of the player's current bag, excluding Key Items.
  # Key Items are considered permanent unlocks and are never lost on blackout.
  def self.snapshot_bag
    return if !$PokemonBag

    snapshot = {}

    # In v21.1, $PokemonBag.pockets is an array of pockets, where each pocket
    # is an array of [item_id, quantity]. We need to iterate through them.
    # The pocket ID for Key Items is typically 8 in standard Essentials,
    # but we can also use GameData::Item.get(item).is_key_item? to be safe.

    GameData::Item.each do |item_data|
      item = item_data.id
      qty = $PokemonBag.pbQuantity(item)
      if qty > 0 && !item_data.is_key_item?
        snapshot[item] = qty
      end
    end

    $PokemonGlobal.raid_bag_snapshot = snapshot
  end

  # Reverts the player's bag to the snapshot taken at the start of the raid.
  # This deletes any non-key items acquired during the failed run.
  def self.revert_bag_to_snapshot
    return if !$PokemonBag || !$PokemonGlobal.raid_bag_snapshot

    # 1. Clear all non-key items from the current bag
    GameData::Item.each do |item_data|
      item = item_data.id
      qty = $PokemonBag.pbQuantity(item)
      if qty > 0 && !item_data.is_key_item?
        # Remove the exact quantity the player currently holds
        $PokemonBag.pbDeleteItem(item, qty)
      end
    end

    # 2. Restore the non-key items from the snapshot
    $PokemonGlobal.raid_bag_snapshot.each do |item, qty|
      $PokemonBag.pbStoreItem(item, qty)
    end

    # Clear the snapshot
    $PokemonGlobal.raid_bag_snapshot = nil
  end

  #-----------------------------------------------------------------------------
  # Raid Progression Logic
  #-----------------------------------------------------------------------------

  # Starts a new raid from Floor 1
  def self.start_raid
    snapshot_bag
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

  # Fails the raid, reverting the bag to the snapshot.
  def self.blackout
    $PokemonGlobal.current_raid_floor = 0
    revert_bag_to_snapshot
    pbMessage(_INTL("You blacked out! All unextracted loot was lost..."))

    # Teleport to Hub
    pbFadeOutIn do
      $game_temp.player_new_map_id = HUB_LOCATION[0]
      $game_temp.player_new_x = HUB_LOCATION[1]
      $game_temp.player_new_y = HUB_LOCATION[2]
      $game_temp.player_new_direction = 2
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
