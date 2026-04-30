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

    found_key = GameData::Trainer::DATA.keys.find do |k|
      k[2] == python_version && (is_vip ? k[1].start_with?("Boss ") : !k[1].start_with?("Boss "))
    end
    if found_key
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

  # Call this in any event script block, e.g., pbFightSpecificBoss(:boss_castform_data)
#===============================================================================
# DBK-Compatible Boss Spawners (Native Bridge)
#===============================================================================

# Triggered by procedural Map Bosses
def pbDynamicBossPokemon
  event = get_character(0)
  return false if !event
  event_id = event.id

  # Fetch the boss key
  if $PokemonGlobal.instance_variable_defined?(:@raid_event_bosses) &&
     $PokemonGlobal.instance_variable_get(:@raid_event_bosses)[event_id]
    chosen_key = $PokemonGlobal.instance_variable_get(:@raid_event_bosses)[event_id]
  else
    boss_keys = ZBox::PokemonFactory.data.keys.select { |k| k.to_s.downcase.start_with?("boss_") }
    return false if boss_keys.empty?
    chosen_key = boss_keys.sample
  end

  # Run the battle (we don't care what it returns anymore!)
  pbFightFactoryBoss(chosen_key)

  # DBK Visibility Cleanup
  $game_player.transparent = false if $game_player

  # Spawn the Rift Portal if applicable
  if defined?(RiftChallenges)
    rpg_event = $game_map.events[event_id]
    RiftChallenges.check_and_spawn_portal(rpg_event.x, rpg_event.y) if rpg_event
  end

  # THE NUCLEAR OPTION: Physically delete the event from the map memory
  pbEraseThisEvent

  return true
end

# Triggered manually in any Event Script box: pbFightSpecificBoss(:boss_castform_data)
def pbFightSpecificBoss(boss_key)
  return pbFightFactoryBoss(boss_key)
end

  # An all-in-one function to dynamically set and start a trainer encounter.
  # Bypasses the need for PBS-compiled Python files by generating NPCTrainer
  # and Pokemon objects dynamically in-memory based on Thematic Pools.
  def pbSetAndStartDynamicTrainer(possible_types = nil, possible_names = nil, victory_switch = "A")
    event = get_character(0)
    return false if !event

    pre_assigned = nil
    if $PokemonGlobal.instance_variable_defined?(:@raid_event_trainers) &&
       $PokemonGlobal.instance_variable_get(:@raid_event_trainers) &&
       $PokemonGlobal.instance_variable_get(:@raid_event_trainers)[event.id]
      pre_assigned = $PokemonGlobal.instance_variable_get(:@raid_event_trainers)[event.id]
    end

    rpg_event = event.instance_variable_get(:@event)
    is_vip = false
    if rpg_event && rpg_event.name.downcase.include?("vip")
      is_vip = true
    end

    possible_types = [possible_types] if possible_types.is_a?(Symbol)
    possible_names = [possible_names] if possible_names.is_a?(String)

    $PokemonGlobal.instance_variable_set(:@dynamic_trainers, {}) if !$PokemonGlobal.instance_variable_defined?(:@dynamic_trainers) || $PokemonGlobal.instance_variable_get(:@dynamic_trainers).nil?
    global_trainers = $PokemonGlobal.instance_variable_get(:@dynamic_trainers)
    event_key = [$game_map.map_id, event.id]

    # 1. Setup Phase: Has this event already generated its trainer data?
    if !global_trainers[event_key]

      chosen_type = nil
      chosen_name = nil

      if pre_assigned
        chosen_type = pre_assigned[0]
        chosen_name = pre_assigned[1]
      else
        # Select randomly from the generic template pools
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
      end

      # Determine Trainer Sprite Graphic Fallback
      graphic_name = nil
      if GameData::TrainerType.exists?(chosen_type)
        graphic_name = "trchar000" # Fallback since we can't reliably predict map sprites natively
      end
      graphic_name = "trchar000" if graphic_name.nil?

      # Calculate Dynamic Scaling based on the player's strongest Pokemon
      level = 10
      if $player && $player.party && !$player.party.empty?
        level = $player.party.map(&:level).max
      end
      level += 2 if is_vip # VIPs are a bit stronger

      party_size = is_vip ? rand(4..6) : rand(1..4)

      # Build the In-Memory Party utilizing the Smart Procedural Encounter Pool
      party = []

      theme_str = $PokemonGlobal.instance_variable_defined?(:@dungeon_area) ? $PokemonGlobal.dungeon_area.to_s : "none"
      theme_data = DungeonThemes.get(theme_str)
      suffix_type = theme_data ? theme_data[:type] : nil

      # DEBUG INJECTION
      debug_msg = "DEBUG - pbSetAndStartDynamicTrainer | Raw $PokemonGlobal.dungeon_area: '#{theme_str}' | Resolved Hash: #{theme_data.inspect}"
      File.open("debug_theme.txt", "a") { |f| f.puts(debug_msg) }
      # END DEBUG INJECTION

      if suffix_type && GameData::Type.exists?(suffix_type)
        if is_vip
          # Elemental Boss Counters
          weaknesses = GameData::Type.get(suffix_type).weaknesses
          if !weaknesses.empty?
            counter_type = weaknesses.sample
            species_pool = GameData::Species.keys.select { |s| GameData::Species.get(s).types.include?(counter_type) }
            species_pool.reject! { |s| GameData::Species.get(s).flags.include?("Legendary") || GameData::Species.get(s).flags.include?("Mythical") } if !species_pool.empty? && GameData::Species.get(species_pool.first).respond_to?(:flags)
          else
            species_pool = ProceduralEncounters.get_pool(chosen_type)
          end
        else
          # Elemental Standard Trainers: Pass the floor type to attempt Dual-Typing synergy!
          species_pool = ProceduralEncounters.get_pool(chosen_type, suffix_type)
        end
      elsif theme_data && suffix_type.nil?
        # TYPELESS THEMES: Both Standard Trainers and VIPs use the floor's attribute pool (No counters)
        if defined?(ProceduralEncounters.get_dynamic_typeless_pool)
          species_pool = ProceduralEncounters.get_dynamic_typeless_pool
        else
          species_pool = ProceduralEncounters.get_pool(chosen_type)
        end
      else
        # Absolute Failsafe
        species_pool = ProceduralEncounters.get_pool(chosen_type)
      end

      # Failsafe if the pool is somehow still empty
      species_pool = ProceduralEncounters::FALLBACK_POOL if species_pool.empty?

      party_species = species_pool.sample(party_size)

      # If we requested more unique species than the pool has, sample might return fewer. We'll duplicate if needed to fill party.
      while party_species.length < party_size && !species_pool.empty?
        party_species.push(species_pool.sample)
      end

      party_species.each do |species|
        pkmn = Pokemon.new(species, level)
        pkmn.calc_stats
        party.push(pkmn)
      end

      RoguelikeExtraction.fought_trainers.push([chosen_type, chosen_name])

      # Save state persistently to global variables
      global_trainers[event_key] = {
        :type => chosen_type,
        :name => chosen_name,
        :party => party
      }

      # Visually update the event graphic on the map right now
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

      # Force Self Switch 'D' to ON immediately after setup is complete
      pbSetSelfSwitch(event.id, "D", true)
    end

    # 2. Transition Guard: If the event is running automatically, halt
    if event.trigger == 3 || event.trigger == 4
      pbSetSelfSwitch(event.id, "D", true)
      return true
    end

    # 3. Battle Phase
    saved_data = global_trainers[event_key]

    if saved_data
      chosen_type = saved_data[:type]
      chosen_name = saved_data[:name]
      party = saved_data[:party]
    else
      pbMessage(_INTL("Error: Trainer data lost for Map {1} Event {2}. Cannot battle.", $game_map.map_id, event.id))
      return false
    end

    display_class = GameData::TrainerType.exists?(chosen_type) ? GameData::TrainerType.get(chosen_type).name : chosen_type.to_s.capitalize
    display_name = is_vip ? "Boss " + chosen_name : chosen_name
    pbMessage(_INTL("{1} {2} would like to battle!", display_class, display_name))

    # Construct the pure In-Memory NPCTrainer
    trainer = NPCTrainer.new(display_name, chosen_type)
    trainer.party = party

    # Start the battle directly bypassing GameData::Trainer PBS compilation
    outcome = TrainerBattle.start(trainer)

    # DBK Visibility Cleanup
    $game_player.transparent = false if $game_player

    if outcome == 1 || outcome == true
      # --- BOUNTY HOOK: SLAYER ---
      if is_vip && $PokemonGlobal && $PokemonGlobal.quests.active_quests.any? { |q| q.id == :Quest1 }
        $game_variables[101] += 1
        if $game_variables[101] >= 5
          completeQuest(:Quest1)
        end
      end
      # --- BOUNTY HOOK: APEX PREDATOR I ---
      if is_vip && $PokemonGlobal && $PokemonGlobal.quests.active_quests.any? { |q| q.id == :Quest6 }
        $game_variables[106] += 1
        if $game_variables[106] >= 15
          completeQuest(:Quest6)
        end
      end
      # --- BOUNTY HOOK: APEX PREDATOR II ---
      if is_vip && $PokemonGlobal && $PokemonGlobal.quests.active_quests.any? { |q| q.id == :Quest7 }
        $game_variables[106] += 1
        if $game_variables[106] >= 30
          completeQuest(:Quest7)
        end
      end
      # ---------------------------

      pbSetSelfSwitch(event.id, victory_switch, true)
      return true
    end

    return false
  end
end
