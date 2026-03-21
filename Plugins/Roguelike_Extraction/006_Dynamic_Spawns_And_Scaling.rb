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

  # Lists of possible trainers.
  # Format: [ trainer_type, trainer_name ]
  DYNAMIC_TRAINERS = [
    [:YOUNGSTER, "RaidBen"],
    [:LASS, "RaidLass"]
  ]

  DYNAMIC_VIPS = [
    [:YOUNGSTER, "RaidBen"], # Example, update with real boss types later
    [:LASS, "RaidLass"]
  ]

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
  event_id = pbMapInterpreter.get_character(0).id

  # Attempt to fetch the pre-calculated trainer assigned by the spawner
  if $PokemonGlobal.instance_variable_defined?(:@raid_event_trainers) &&
     $PokemonGlobal.instance_variable_get(:@raid_event_trainers) &&
     $PokemonGlobal.instance_variable_get(:@raid_event_trainers)[event_id]

    chosen_trainer = $PokemonGlobal.instance_variable_get(:@raid_event_trainers)[event_id]
  else
    # Failsafe if the spawner didn't run or wasn't assigned properly
    pool = is_vip ? RoguelikeExtraction::DYNAMIC_VIPS : RoguelikeExtraction::DYNAMIC_TRAINERS
    available = pool.reject { |t| RoguelikeExtraction.fought_trainers.include?(t) }
    available = pool if available.empty?
    chosen_trainer = available.sample
  end

  trainer_type = chosen_trainer[0]
  trainer_name = chosen_trainer[1]

  RoguelikeExtraction.fought_trainers.push(chosen_trainer)

  # We no longer need to update the sprite here because the Spawner does it on map entry!

  # Start the battle using the calculated version (v21.1 Standard)
  TrainerBattle.start(trainer_type, trainer_name, version)
end

class Interpreter
  # An all-in-one function to dynamically set and start a trainer encounter.
  # Intelligently handles being placed in a Parallel Process: it will update
  # its graphic immediately on map load, then convert itself into an Action Button
  # event to wait for player interaction without triggering the battle instantly.
  def pbSetAndStartDynamicTrainer(possible_types = nil, possible_names = nil, victory_switch = "A")
    # If no types are provided, pull the keys from our dynamically generated pool
    if !possible_types || possible_types.empty?
      possible_types = RoguelikeExtraction::DYNAMIC_TRAINERS.map { |t| t[0] }.uniq
    end

    event = get_character(0)
    return false if !event

    # 1. Setup Phase: Has this event already generated its trainer data?
    # We store the selected trainer persistently on this specific event instance.
    if !event.instance_variable_defined?(:@dynamic_trainer_initialized) || !event.instance_variable_get(:@dynamic_trainer_initialized)

      chosen_type = possible_types.sample
      if possible_names && !possible_names.empty?
        chosen_name = possible_names.sample
      else
        # Pull from the existing generated pool of trainers for this specific class
        pool_names = RoguelikeExtraction::DYNAMIC_TRAINERS.select { |t| t[0] == chosen_type }.map { |t| t[1] }
        chosen_name = pool_names.empty? ? chosen_type.to_s.capitalize : pool_names.sample
      end

      # Dynamically update the overworld graphic instance safely
      event.character_name = "trainer_#{chosen_type.to_s}"
      event.character_hue = 0
      event.refresh if event.respond_to?(:refresh)

      # Save state to the event
      event.instance_variable_set(:@dynamic_trainer_initialized, true)
      event.instance_variable_set(:@dynamic_trainer_type, chosen_type)
      event.instance_variable_set(:@dynamic_trainer_name, chosen_name)

      # If the event is running automatically (Autorun or Parallel Process),
      # we convert it to an Action Button event and return early to prevent the battle from triggering.
      if event.trigger == 3 || event.trigger == 4
        event.instance_variable_set(:@trigger, 0) # Convert to Action Button
        return true # Stop execution of this script block so the battle does not start yet
      end
    end

    # 2. Battle Phase: The player has interacted with the event
    # Retrieve the saved trainer state
    chosen_type = event.instance_variable_get(:@dynamic_trainer_type) || possible_types.sample
    chosen_name = event.instance_variable_get(:@dynamic_trainer_name) || "Trainer"

    version = RoguelikeExtraction.calculate_trainer_version

    # Pre-battle message
    display_class = GameData::TrainerType.exists?(chosen_type) ? GameData::TrainerType.get(chosen_type).name : chosen_type.to_s.capitalize
    pbMessage(_INTL("{1} {2} would like to battle!", display_class, chosen_name))

    # Start the battle
    outcome = TrainerBattle.start(chosen_type, chosen_name, version)

    # Check if player won
    if outcome
      pbSetSelfSwitch(event.id, victory_switch, true)
      return true
    end

    return false
  end
end
