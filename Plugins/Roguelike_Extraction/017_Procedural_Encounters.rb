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

  TRAINER_POOLS = {
    :HIKER       => [:GEODUDE, :GRAVELER, :GOLEM, :ONIX, :MACHOP, :MACHOKE, :MACHAMP, :RHYHORN, :NOSEPASS],
    :SWIMMER_M   => [:TENTACOOL, :TENTACRUEL, :SHELLDER, :MAGIKARP, :GOLDEEN, :STARYU, :HORSEA, :KRABBY],
    :SWIMMER_F   => [:TENTACOOL, :TENTACRUEL, :SHELLDER, :MAGIKARP, :GOLDEEN, :STARYU, :HORSEA, :KRABBY],
    :BURGLAR     => [:KOFFING, :VULPIX, :GRIMER, :ZUBAT, :GROWLITHE, :HOUNDOUR],
    :BUGCATCHER  => [:CATERPIE, :METAPOD, :BUTTERFREE, :WEEDLE, :KAKUNA, :BEEDRILL, :PARAS, :VENONAT, :SCYTHER, :PINSIR],
    :LASS        => [:PIDGEY, :RATTATA, :NIDORANfE, :CLEFAIRY, :JIGGLYPUFF, :ODDISH, :MEOWTH],
    :YOUNGSTER   => [:PIDGEY, :RATTATA, :NIDORANmA, :MANKEY, :EKANS, :SPEAROW, :SANDSHREW],
    :BIRD_KEEPER => [:PIDGEY, :PIDGEOTTO, :PIDGEOT, :SPEAROW, :FEAROW, :DODUO, :DODRIO, :FARFETCHD],
    :SAILOR      => [:TENTACOOL, :SHELLDER, :KRABBY, :KINGLER, :HORSEA, :SEADRA, :STARYU, :STARMIE],
    :BLACKBELT   => [:MACHOP, :MACHOKE, :MACHAMP, :MANKEY, :PRIMEAPE, :HITMONLEE, :HITMONCHAN],
    :TEAMROCKET_M=> [:ZUBAT, :KOFFING, :GRIMER, :RATTATA, :RATICATE, :EKANS, :ARBOK, :MACHOP, :DROWZEE],
    :TEAMROCKET_F=> [:ZUBAT, :KOFFING, :GRIMER, :RATTATA, :RATICATE, :EKANS, :ARBOK, :MACHOP, :DROWZEE],
    :COOLTRAINER_M=>[:CHARMANDER, :BULBASAUR, :SQUIRTLE, :PIKACHU, :EEVEE, :NIDORINO, :NIDORINA, :KADABRA],
    :COOLTRAINER_F=>[:CHARMANDER, :BULBASAUR, :SQUIRTLE, :PIKACHU, :EEVEE, :NIDORINO, :NIDORINA, :KADABRA],
    :SCIENTIST   => [:VOLTORB, :ELECTRODE, :MAGNEMITE, :MAGNETON, :PORYGON, :KOFFING, :WEEZING, :MUK],
    :SUPERNERD   => [:VOLTORB, :ELECTRODE, :MAGNEMITE, :MAGNETON, :PORYGON, :KOFFING, :WEEZING, :MUK]
  }

  def self.get_pool(trainer_class)
    return TRAINER_POOLS[trainer_class] if TRAINER_POOLS.has_key?(trainer_class)
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

    pbMessage(_INTL("DEBUG: Floor {1} Theme is {2}", floor, chosen_theme)) if $DEBUG

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