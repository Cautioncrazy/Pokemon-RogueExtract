#===============================================================================
# Procedural Encounters: Thematic Trainer Pools
#===============================================================================
# Replaces offline Python PBS trainer generation with 100% on-the-fly,
# smart in-memory generation.
#
# Maps specific Trainer Classes to thematic pools of Pokémon species.
# When pbDynamicTrainer spawns a trainer, it pulls their team from the matching
# pool, scaling their levels to the player and randomizing their sizes.
#===============================================================================

module ProceduralEncounters
  # A robust fallback pool in case a trainer class isn't explicitly defined below
  FALLBACK_POOL = [:RATTATA, :PIDGEY, :ZUBAT, :MEOWTH, :GEODUDE, :MACHOP, :ABRA, :GASTLY]

  # Maps Trainer Classes to their lore-accurate elemental typing
  TRAINER_LORE_TYPES = {
    :AROMALADY       => :GRASS,
    :BEAUTY          => :FAIRY,
    :BIKER           => :POISON,
    :BIRDKEEPER      => :FLYING,
    :BUGCATCHER      => :BUG,
    :BURGLAR         => :DARK,
    :CHANNELER       => :GHOST,
    :CUEBALL         => :FIGHTING,
    :ENGINEER        => :ELECTRIC,
    :FISHERMAN       => :WATER,
    :GAMBLER         => :DARK,
    :HIKER           => :ROCK,
    :JUGGLER         => :PSYCHIC,
    :PAINTER         => :FAIRY,
    :POKEMANIAC      => :DRAGON,
    :ROCKER          => :ELECTRIC,
    :RUINMANIAC      => :GROUND,
    :SAILOR          => :WATER,
    :SCIENTIST       => :ELECTRIC,
    :SUPERNERD       => :STEEL,
    :TAMER           => :NORMAL,
    :BLACKBELT       => :FIGHTING,
    :CRUSHGIRL       => :FIGHTING,
    :CAMPER          => :GROUND,
    :PICNICKER       => :GRASS,
    :YOUNGSTER       => :NORMAL,
    :LASS            => :FAIRY,
    :POKEMONRANGER_M => :GRASS,
    :POKEMONRANGER_F => :GRASS,
    :PSYCHIC_M       => :PSYCHIC,
    :PSYCHIC_F       => :PSYCHIC,
    :SWIMMER_M       => :WATER,
    :SWIMMER_F       => :WATER,
    :SWIMMER2_M      => :WATER,
    :SWIMMER2_F      => :WATER,
    :TUBER_M         => :WATER,
    :TUBER_F         => :WATER,
    :TUBER2_M        => :WATER,
    :TUBER2_F        => :WATER,
    :TEAMROCKET_M    => :POISON,
    :TEAMROCKET_F    => :POISON,
    :ROCKETBOSS      => :DARK
  }

  def self.get_pool(trainer_class, floor_type = nil)
    lore_type = TRAINER_LORE_TYPES[trainer_class]

    # 1. Dual-Type Attempt (Lore Type + Floor Type)
    if lore_type && floor_type && GameData::Type.exists?(lore_type) && GameData::Type.exists?(floor_type)
      dual_pool = GameData::Species.keys.select do |s|
        sp_types = GameData::Species.get(s).types
        sp_types.include?(lore_type) && sp_types.include?(floor_type)
      end

      if !dual_pool.empty? && GameData::Species.get(dual_pool.first).respond_to?(:flags)
        dual_pool.reject! { |s| GameData::Species.get(s).flags.include?("Legendary") || GameData::Species.get(s).flags.include?("Mythical") }
      end

      # Require at least 2 unique species to avoid spamming a single Pokémon
      if dual_pool.length >= 2
        if $DEBUG
          File.open("debug_theme.txt", "a") { |f| f.puts("DEBUG - get_pool | Trainer #{trainer_class} using Dual Type #{lore_type}/#{floor_type}") }
        end
        return dual_pool
      end
    end

    # 2. Floor Type Fallback
    if floor_type && GameData::Type.exists?(floor_type)
      floor_pool = GameData::Species.keys.select { |s| GameData::Species.get(s).types.include?(floor_type) }
      if !floor_pool.empty? && GameData::Species.get(floor_pool.first).respond_to?(:flags)
        floor_pool.reject! { |s| GameData::Species.get(s).flags.include?("Legendary") || GameData::Species.get(s).flags.include?("Mythical") }
      end
      if !floor_pool.empty?
        if $DEBUG
          File.open("debug_theme.txt", "a") { |f| f.puts("DEBUG - get_pool | Trainer #{trainer_class} falling back to Floor Type #{floor_type}") }
        end
        return floor_pool
      end
    end

    # 3. Lore Type Fallback
    if lore_type && GameData::Type.exists?(lore_type)
      lore_pool = GameData::Species.keys.select { |s| GameData::Species.get(s).types.include?(lore_type) }
      if !lore_pool.empty? && GameData::Species.get(lore_pool.first).respond_to?(:flags)
        lore_pool.reject! { |s| GameData::Species.get(s).flags.include?("Legendary") || GameData::Species.get(s).flags.include?("Mythical") }
      end
      if $DEBUG
        File.open("debug_theme.txt", "a") { |f| f.puts("DEBUG - get_pool | Trainer #{trainer_class} using Lore Type #{lore_type}") }
      end
      return lore_pool unless lore_pool.empty?
    end

    return FALLBACK_POOL
  end

  # ============================================================================
  # Wild Encounter Thematic Pools
  # ============================================================================

  def self.get_dynamic_typeless_pool
    floor = $PokemonGlobal.instance_variable_defined?(:@current_raid_floor) ? $PokemonGlobal.current_raid_floor : 1

    # Seed RNG with the floor number so the theme is consistent for the whole floor
    srand(floor * 100)
    themes = [:HIGH_SPEED, :HEAVYWEIGHT, :MONSTER_EGG, :HIGH_BST, :WEATHER_SETTERS, :HARD_TO_CATCH]
    chosen_theme = themes.sample
    srand # Reset RNG back to normal

    if $DEBUG
      File.open("debug_theme.txt", "a") { |f| f.puts("DEBUG - get_dynamic_typeless_pool | Floor #{floor} Theme is #{chosen_theme}") }
    end

    pool = GameData::Species.keys.select do |s|
      sp = GameData::Species.get(s)
      next false if sp.flags.include?("Legendary") || sp.flags.include?("Mythical")

      case chosen_theme
      when :HIGH_SPEED then sp.base_stats[:SPEED] >= 100
      when :HEAVYWEIGHT then sp.weight >= 1000 # 100.0 kg
      when :MONSTER_EGG then sp.egg_groups.include?(:Monster)
      when :HIGH_BST then sp.base_stats.values.sum >= 450
      when :WEATHER_SETTERS then sp.abilities.any? { |a| [:DROUGHT, :DRIZZLE, :SANDSTREAM, :SNOWWARNING].include?(a) }
      when :HARD_TO_CATCH then sp.catch_rate <= 45
      else true
      end
    end

    return pool.empty? ? FALLBACK_POOL : pool
  end

  def self.get_wild_pool(theme)
    theme_data = DungeonThemes.get(theme)

    if theme_data && theme_data[:type]
      # Scan global dictionary for the registered type
      pool = GameData::Species.keys.select { |s| GameData::Species.get(s).types.include?(theme_data[:type]) }

      # Exclude legendaries/mythicals
      if !pool.empty? && GameData::Species.get(pool.first).respond_to?(:flags)
        pool.reject! { |s| GameData::Species.get(s).flags.include?("Legendary") || GameData::Species.get(s).flags.include?("Mythical") }
      end

      return pool unless pool.empty?
    end

    # If a theme was found but it has no elemental type, generate a dynamic attribute pool
    if theme_data && theme_data[:type].nil?
      return get_dynamic_typeless_pool
    end

    # Absolute failsafe for missing/nil data
    return FALLBACK_POOL
  end
end