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
    [:YOUNGSTER, "Ben"],
    [:YOUNGSTER, "Calvin"],
    [:YOUNGSTER, "Dan"],
    [:LASS, "Ali"],
    [:LASS, "Betty"],
    [:LASS, "Cathy"],
    [:HIKER, "Anthony"],
    [:HIKER, "Bruce"],
    [:HIKER, "Clark"],
    [:CAMPER, "Dave"],
    [:CAMPER, "Edgar"],
    [:CAMPER, "Frank"],
    [:PICNICKER, "Gina"],
    [:PICNICKER, "Helen"],
    [:PICNICKER, "Irene"],
    [:BUGCATCHER, "James"],
    [:BUGCATCHER, "Ken"],
    [:BUGCATCHER, "Leo"],
    [:SUPERNERD, "Mike"],
    [:SUPERNERD, "Nick"],
    [:SUPERNERD, "Owen"]
  ]

  DYNAMIC_VIPS = [
    [:ACE_TRAINER_M, "Boss Ace"],
    [:ACE_TRAINER_F, "Boss Alice"],
    [:VETERAN_M, "Boss Victor"],
    [:VETERAN_F, "Boss Victoria"],
    [:ROUGHNECK, "Boss Rocco"]
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
    version = (floor - 1) / 3

    # Ensure it's at least 0 (base version in PBS) and capped at 2 (max PBS version)
    version = 0 if version < 0
    version = 2 if version > 2
    return version
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
  # To avoid RPG Maker XP's notorious script box word-wrapping crash (SyntaxError),
  # we provide a shorter alias that accepts a flat list of arguments.
  # Usage: pbDynamicTrainer(:YOUNGSTER, :LASS, "B")
  def pbDynamicTrainer(*args)
    victory_switch = "A"
    possible_types = []

    args.each do |arg|
      if arg.is_a?(String) && arg.length == 1
        victory_switch = arg
      elsif arg.is_a?(Symbol)
        possible_types.push(arg)
      elsif arg.is_a?(Array)
        possible_types.concat(arg.select { |i| i.is_a?(Symbol) })
      end
    end

    pbSetAndStartDynamicTrainer(possible_types, nil, victory_switch)
  end

  # An all-in-one function to dynamically set and start a trainer encounter.
  # Intelligently handles being placed in a Parallel Process: it will update
  # its graphic immediately on map load, then convert itself into an Action Button
  # event to wait for player interaction without triggering the battle instantly.
  def pbSetAndStartDynamicTrainer(possible_types = nil, possible_names = nil, victory_switch = "A")
    event = get_character(0)
    return false if !event

    # Check if the Spawner (002_Dynamic_Event_Spawner.rb) already pre-calculated this event's trainer.
    # If this is an event named "VIP" or "Trainer", the spawner assigns it globally.
    pre_assigned = nil
    if $PokemonGlobal.instance_variable_defined?(:@raid_event_trainers) &&
       $PokemonGlobal.instance_variable_get(:@raid_event_trainers) &&
       $PokemonGlobal.instance_variable_get(:@raid_event_trainers)[event.id]
      pre_assigned = $PokemonGlobal.instance_variable_get(:@raid_event_trainers)[event.id]
    end

    # Fix Array coercion to prevent 'empty?' / 'sample' on Symbols if user bypasses the alias
    possible_types = [possible_types] if possible_types.is_a?(Symbol)
    possible_names = [possible_names] if possible_names.is_a?(String)

    # If no types are provided, pull the keys from our dynamically generated pool
    if !possible_types || (!possible_types.is_a?(Array) || possible_types.empty?)
      possible_types = pre_assigned ? [pre_assigned[0]] : RoguelikeExtraction::DYNAMIC_TRAINERS.map { |t| t[0] }.uniq
    end

    # 1. Setup Phase: Has this event already generated its trainer data?
    # We store the selected trainer persistently on this specific event instance.
    if !event.instance_variable_defined?(:@dynamic_trainer_initialized) || !event.instance_variable_get(:@dynamic_trainer_initialized)

      # Use the pre-assigned trainer from the spawner, otherwise randomly generate
      if pre_assigned
        chosen_type = pre_assigned[0]
        chosen_name = pre_assigned[1]
      else
        if possible_names && possible_names.is_a?(Array) && !possible_names.empty?
          # If names are explicitly provided, we randomly construct pairs and filter against fought trainers
          available_pairs = []
          possible_types.each do |type|
            possible_names.each { |name| available_pairs.push([type, name]) }
          end
        else
          # Otherwise filter the global pool by the requested types
          available_pairs = RoguelikeExtraction::DYNAMIC_TRAINERS.select { |t| possible_types.include?(t[0]) }

          # Failsafe if the types provided don't exist in our global pool at all.
          # We must pull a random valid pair from the entire pool so the game doesn't crash or prompt for creation.
          if available_pairs.empty?
            available_pairs = RoguelikeExtraction::DYNAMIC_TRAINERS.dup
          end
        end

        # Preserve the base pool before filtering
        base_pool = available_pairs.dup

        # Remove trainers already fought on this floor to avoid duplicates
        available_pairs = available_pairs.reject { |t| RoguelikeExtraction.fought_trainers.include?(t) }

        # If all available trainers of this type are exhausted on this floor, fallback to reusing the base pool!
        # Do not dynamically construct names (e.g., `type.to_s.capitalize`) or it triggers manual PBS creation.
        available_pairs = base_pool if available_pairs.empty?

        chosen_pair = available_pairs.sample
        chosen_type = chosen_pair[0]
        chosen_name = chosen_pair[1]
      end

      # Register this newly created trainer so they aren't generated again on this floor
      RoguelikeExtraction.fought_trainers.push([chosen_type, chosen_name])

      # Dynamically update the overworld graphic instance permanently in memory for all pages
      graphic_name = "trainer_#{chosen_type.to_s}"

      # Modify the underlying event pages so that when Self Switch 'D' transitions
      # to Page 2 (Action Button), it inherently inherits the correct graphic without
      # needing another active script call to render it.
      rpg_event = event.instance_variable_get(:@event)
      if rpg_event && rpg_event.pages
        rpg_event.pages.each do |page|
          if page.graphic
            page.graphic.character_name = graphic_name
            page.graphic.character_hue = 0
          end
        end
      end

      event.character_name = graphic_name
      event.character_hue = 0
      event.refresh if event.respond_to?(:refresh)

      # Save state to the event
      event.instance_variable_set(:@dynamic_trainer_initialized, true)
      event.instance_variable_set(:@dynamic_trainer_type, chosen_type)
      event.instance_variable_set(:@dynamic_trainer_name, chosen_name)

      # If the event is running automatically (Autorun or Parallel Process),
      # we assume this is the Setup Page (Page 1). We automatically turn ON
      # Self Switch 'D' so the event transitions to an Action Button page (Page 2)
      # and return early to prevent the battle from triggering immediately.
      if event.trigger == 3 || event.trigger == 4
        pbSetSelfSwitch(event.id, "D", true)
        return true # Stop execution of this script block so the battle does not start yet
      end
    end

    # 2. Battle Phase: The player has interacted with the event (e.g., on Page 2)
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
