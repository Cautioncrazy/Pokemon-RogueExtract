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
    [:TEAMROCKET_M, "Boss Grunt"],
    [:BEAUTY, "Boss Bella"],
    [:FISHERMAN, "Boss Finn"],
    [:SWIMMER2_F, "Boss Ariel"],
    [:CHAMPION, "Boss Blue"]
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

  # Define higher tier items for the Black Market Trader
  BLACK_MARKET_POOL = [
    :REVIVE, :MAXREVIVE, :FULLRESTORE, :MAXPOTION,
    :ELIXIR, :MAXELIXIR, :ETHER, :MAXETHER, :RARECANDY,
    :PPUP, :PPMAX, :NUGGET, :MASTERBALL, :LEFTOVERS,
    :CHOICEBAND, :CHOICESCARF, :CHOICESPECS, :LIFEORB
  ]

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

# To be placed inside the Early Extract NPC
def pbEarlyExtractPrompt
  pbMessage(_INTL("Would you like to safely extract early?\\nThis will reset current floor but you will keep all loot found!"))
  if pbConfirmMessage("Extract?")
    pbMessage(_INTL("Visit any Abra to extract early!"))
    pbExtractRaid
  end
end

# To be placed inside the Black Market Trader NPC
def pbBlackMarketTrader
  pbMessage(_INTL("Psst... you look like you need some of the good stuff.\\nI got items you won't find anywhere else, for a price."))

  # Create a custom stock list based on the floor tier
  floor = $PokemonGlobal.current_raid_floor || 1
  tier = (floor - 1) / 4

  # Scale stock amount based on tier, max 6 items
  stock_count = 3 + tier
  stock_count = 6 if stock_count > 6

  stock = RoguelikeExtraction::BLACK_MARKET_POOL.sample(stock_count)

  # We use the standard Pokemon Mart but we can customize the dialogue
  pbPokemonMart(stock, _INTL("Anything catch your eye?"), _INTL("Keep it quiet, alright?"))
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
    # Check if a Python trainer exists natively first
    floor = $PokemonGlobal.current_raid_floor || 1
    map_id = $game_map.map_id
    python_version = (map_id * 100) + floor

    found_keys = GameData::Trainer::DATA.keys.select do |k|
      k[2] == python_version && (is_vip ? k[1].start_with?("Boss ") : !k[1].start_with?("Boss "))
    end

    $PokemonGlobal.assigned_dynamic_trainers ||= []
    available_keys = found_keys.reject { |k| $PokemonGlobal.assigned_dynamic_trainers.include?(k) }
    available_keys = found_keys if available_keys.empty? && !found_keys.empty?

    found_key = available_keys.sample

    if found_key
      $PokemonGlobal.assigned_dynamic_trainers.push(found_key)
      chosen_trainer = [found_key[0], found_key[1], python_version]
    else
      pool = is_vip ? RoguelikeExtraction::DYNAMIC_VIPS : RoguelikeExtraction::DYNAMIC_TRAINERS
      available = pool.reject { |t| RoguelikeExtraction.fought_trainers.include?(t) }
      available = pool if available.empty?
      chosen_trainer = available.sample
    end
  end

  trainer_type = chosen_trainer[0]
  trainer_name = chosen_trainer[1]

  # If the python generator assigned an explicit version to this trainer, override the calculated tier version
  version = chosen_trainer[2] if chosen_trainer.length > 2

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

    # Determine if this event is natively a VIP based on its RPG Maker editor name
    rpg_event = event.instance_variable_get(:@event)
    is_vip = false
    if rpg_event && rpg_event.name.downcase.include?("vip")
      is_vip = true
    end

    # Fix Array coercion to prevent 'empty?' / 'sample' on Symbols if user bypasses the alias
    possible_types = [possible_types] if possible_types.is_a?(Symbol)
    possible_names = [possible_names] if possible_names.is_a?(String)

    # Initialize the global storage hash if it doesn't exist
    $PokemonGlobal.instance_variable_set(:@dynamic_trainers, {}) if !$PokemonGlobal.instance_variable_defined?(:@dynamic_trainers) || $PokemonGlobal.instance_variable_get(:@dynamic_trainers).nil?
    global_trainers = $PokemonGlobal.instance_variable_get(:@dynamic_trainers)
    event_key = [$game_map.map_id, event.id]

    # 1. Setup Phase: Has this event already generated its trainer data?
    # We store the selected trainer globally so it persists across map reloads.
    if !global_trainers[event_key]

      chosen_type = nil
      chosen_name = nil
      chosen_version = nil

      if pre_assigned
        chosen_type = pre_assigned[0]
        chosen_name = pre_assigned[1]
        chosen_version = pre_assigned.length > 2 ? pre_assigned[2] : RoguelikeExtraction.calculate_trainer_version
      else
        # Gather all existing trainers generated by Python for this specific map
        valid_trainers = []
        GameData::Trainer.each do |trainer|
          # Match map ID
          if (trainer.version / 100) == $game_map.map_id
            # Filter by Boss status
            if is_vip
              valid_trainers.push(trainer) if trainer.name.start_with?("Boss ")
            else
              valid_trainers.push(trainer) if !trainer.name.start_with?("Boss ")
            end
          end
        end

        # Filter against trainers we've already fought on this floor
        available_trainers = valid_trainers.reject do |t|
          RoguelikeExtraction.fought_trainers.any? { |fought| fought[0] == t.trainer_type && fought[1] == t.name }
        end
        # Fallback to full valid pool if we've exhausted all available
        available_trainers = valid_trainers if available_trainers.empty?

        if !available_trainers.empty?
          # We found valid generated trainers, pick one!
          sampled_trainer = available_trainers.sample
          chosen_type = sampled_trainer.trainer_type
          chosen_name = sampled_trainer.name
          chosen_version = sampled_trainer.version
        else
          # Failsafe: Python generator failed or no matching trainers found on this map.
          # Fallback to the generic hardcoded templates so the game doesn't crash.
          if !possible_types || (!possible_types.is_a?(Array) || possible_types.empty?)
            target_pool = is_vip ? RoguelikeExtraction::DYNAMIC_VIPS : RoguelikeExtraction::DYNAMIC_TRAINERS
            possible_types = target_pool.map { |t| t[0] }.uniq
          end

          target_pool = is_vip ? RoguelikeExtraction::DYNAMIC_VIPS : RoguelikeExtraction::DYNAMIC_TRAINERS
          available_pairs = target_pool.select { |t| possible_types.include?(t[0]) }
          available_pairs = target_pool.dup if available_pairs.empty?

          base_pool = available_pairs.dup
          available_pairs = available_pairs.reject { |t| RoguelikeExtraction.fought_trainers.include?(t) }
          available_pairs = base_pool if available_pairs.empty?

          chosen_pair = available_pairs.sample
          chosen_type = chosen_pair[0]
          chosen_name = chosen_pair[1]
          chosen_version = RoguelikeExtraction.calculate_trainer_version

          # Print warning for the developer
          print("Warning: No valid Python trainers found for Map #{$game_map.map_id}. Falling back to template #{chosen_type} #{chosen_name}.")
        end
      end

      # Register this newly created trainer so they aren't generated again on this floor
      RoguelikeExtraction.fought_trainers.push([chosen_type, chosen_name])

      # Save state persistently to global variables
      global_trainers[event_key] = {
        :type => chosen_type,
        :name => chosen_name,
        :version => chosen_version
      }

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

      # Force Self Switch 'D' to ON immediately after setup is complete so the event
      # correctly flips to Page 2 (the interactable battle page)
      pbSetSelfSwitch(event.id, "D", true)
    end

    # 2. Transition Guard: If the event is running automatically (Autorun or Parallel Process),
    # we assume this is the Setup Page (Page 1). We MUST return early to prevent the battle
    # from triggering immediately. This must reside outside the initialization block so that
    # if an event reverts to Page 1 (e.g., after an extract reset), it safely halts again.
    if event.trigger == 3 || event.trigger == 4
      pbSetSelfSwitch(event.id, "D", true) # Safety redundancy
      return true # Stop execution of this script block so the battle does not start yet
    end

    # 3. Battle Phase: The player has interacted with the event (e.g., on Page 2)
    # Retrieve the exact trainer state saved globally during setup
    saved_data = global_trainers[event_key]

    if saved_data
      chosen_type = saved_data[:type]
      chosen_name = saved_data[:name]
      chosen_version = saved_data[:version]
    else
      # Safety Fallback: if data is somehow missing, calculate manually to prevent crash
      pbMessage(_INTL("Error: Trainer data lost for Map {1} Event {2}. Falling back.", $game_map.map_id, event.id))
      chosen_type = is_vip ? RoguelikeExtraction::DYNAMIC_VIPS.sample[0] : RoguelikeExtraction::DYNAMIC_TRAINERS.sample[0]
      chosen_name = "Trainer"
      chosen_version = RoguelikeExtraction.calculate_trainer_version
    end

    # Pre-battle message
    display_class = GameData::TrainerType.exists?(chosen_type) ? GameData::TrainerType.get(chosen_type).name : chosen_type.to_s.capitalize
    pbMessage(_INTL("{1} {2} would like to battle!", display_class, chosen_name))

    # Start the battle
    outcome = TrainerBattle.start(chosen_type, chosen_name, chosen_version)

    # Check if player won
    if outcome
      pbSetSelfSwitch(event.id, victory_switch, true)
      return true
    end

    return false
  end
end
