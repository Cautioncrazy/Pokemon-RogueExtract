#===============================================================================
# Dynamic Event Spawns & Scaling System
#===============================================================================

module RoguelikeExtraction
  # Defines scaling loot pools based on the player's current floor.
  # The pools strictly exclude revive items.
  # Format: { Floor_Tier => [ array_of_possible_items ] }
  CHEST_LOOT_POOLS = {
    0 => [:POKEBALL, :POTION, :ANTIDOTE, :PARALYZEHEAL, :AWAKENING, :BURNHEAL, :ICEHEAL, :REPEL, :ESCAPEROPE],
    1 => [:GREATBALL, :SUPERPOTION, :FULLHEAL, :SUPERREPEL, :RARECANDY, :ETHER],
    2 => [:ULTRABALL, :HYPERPOTION, :FULLHEAL, :MAXREPEL, :RARECANDY, :MAXETHER, :ELIXIR],
    3 => [:ULTRABALL, :MAXPOTION, :FULLRESTORE, :MAXREPEL, :RARECANDY, :MAXELIXIR]
  }

  def self.dynamic_chest_loot
    floor = $PokemonGlobal.current_raid_floor
    tier = (floor - 1) / 4

    # Cap at the max tier we have defined
    max_tier = CHEST_LOOT_POOLS.keys.max
    tier = max_tier if tier > max_tier

    pool = CHEST_LOOT_POOLS[tier]
    return [:POKEBALL, 1] if !pool || pool.empty? # Safe fallback

    item = pool.sample

    # Calculate amount. Higher floors give slightly more items.
    amount = 1
    if rand(100) < 30 # 30% chance to get an extra item
      amount += 1
    end
    if tier >= 2 && rand(100) < 20 # 20% chance to get another extra if tier 2+
      amount += 1
    end

    return [item, amount]
  end

  # Calculates the trainer version based on the current floor.
  # Track defeated trainers on this floor to avoid duplicates
  def self.fought_trainers
    $PokemonGlobal.instance_variable_set(:@fought_raid_trainers, []) if !$PokemonGlobal.instance_variable_defined?(:@fought_raid_trainers) || $PokemonGlobal.instance_variable_get(:@fought_raid_trainers).nil?
    return $PokemonGlobal.instance_variable_get(:@fought_raid_trainers)
  end

  def self.calculate_trainer_version
    floor = $PokemonGlobal.current_raid_floor
    # We want versions to scale slowly.
    # Floor 1-3 -> Version 0
    # Floor 4-6 -> Version 1
    # Floor 7-9 -> Version 2
    # etc.
    version = (floor - 1) / 3

    # Ensure it's at least 0 (base version in PBS)
    return [version, 0].max
  end
end

#===============================================================================
# Helper Methods for RPG Maker Events
#===============================================================================

# To be placed inside a Chest event
def pbDynamicChestLoot
  item_data = RoguelikeExtraction.dynamic_chest_loot
  item = item_data[0]
  amount = item_data[1]

  pbReceiveItem(item, amount)

  # Set self switch A to ON so the chest graphic changes to open
  # We extract the event ID automatically so the user doesn't have to pass it
  event_id = pbMapInterpreter.get_character(0).id
  pbSetSelfSwitch(event_id, "A", true)
end

# To be placed inside a Trainer or VIP event
def pbDynamicTrainerBattle(is_vip = false)
  version = RoguelikeExtraction.calculate_trainer_version

  # Lists of possible trainers.
  # Format: [ trainer_type, trainer_name ]
  trainers_pool = [
    [:YOUNGSTER, "RaidBen"],
    [:LASS, "RaidLass"]
  ]

  vips_pool = [
    [:YOUNGSTER, "RaidBen"], # Example, update with real boss types later
    [:LASS, "RaidLass"]
  ]

  pool = is_vip ? vips_pool : trainers_pool

  # Filter out trainers we've already fought on this floor
  available = pool.reject { |t| RoguelikeExtraction.fought_trainers.include?(t) }

  # If we run out of unique trainers, fallback to the full pool
  available = pool if available.empty?

  chosen_trainer = available.sample
  trainer_type = chosen_trainer[0]
  trainer_name = chosen_trainer[1]

  RoguelikeExtraction.fought_trainers.push(chosen_trainer)

  # Start the battle using the calculated version (v21.1 Standard)
  TrainerBattle.start(trainer_type, trainer_name, version)
end
