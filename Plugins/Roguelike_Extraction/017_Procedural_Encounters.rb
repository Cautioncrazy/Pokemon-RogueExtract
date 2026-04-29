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
  WILD_POOLS = {
    :CAVE       => [:ZUBAT, :GEODUDE, :MACHOP, :GOLBAT, :GRAVELER, :CLEFAIRY, :PARAS, :ONIX],
    :FOREST     => [:CATERPIE, :METAPOD, :WEEDLE, :KAKUNA, :PIDGEY, :ODDISH, :BELLSPROUT, :VENONAT],
    :FOREST_ICE => [:SWINUB, :SNEASEL, :DELIBIRD, :SEEL, :JYNX, :LAPRAS],
    :WATER      => [:TENTACOOL, :MAGIKARP, :POLIWAG, :GOLDEEN, :STARYU, :SLOWPOKE, :SHELLDER],
    :LAB        => [:VOLTORB, :MAGNEMITE, :PORYGON, :KOFFING, :GRIMER, :DITTO, :ELECTRODE]
  }

  def self.get_wild_pool(theme)
    theme_sym = theme.to_s.upcase.to_sym
    return WILD_POOLS[theme_sym] if WILD_POOLS.has_key?(theme_sym)

    # If the theme has an underscore (e.g. FOREST_ICE), parse and filter
    if theme.to_s.include?('_')
      parts = theme.to_s.split('_')
      base_theme = parts.first.upcase.to_sym
      suffix_type = parts.last.upcase.to_sym

      base_pool = WILD_POOLS[base_theme] || []

      # Attempt Filter: Grab the array for the base_theme and filter it
      filtered_pool = base_pool.select { |s| GameData::Species.get(s).types.include?(suffix_type) }

      # Failsafe 1 (Global Scan): If filtered_pool is empty, bypass the base pool and scan globally
      if filtered_pool.empty?
        filtered_pool = GameData::Species.keys.select { |s| GameData::Species.get(s).types.include?(suffix_type) }
        # Exclude legendaries/mythicals where appropriate if possible
        if !filtered_pool.empty? && GameData::Species.get(filtered_pool.first).respond_to?(:flags)
          filtered_pool.reject! { |s| GameData::Species.get(s).flags.include?("Legendary") || GameData::Species.get(s).flags.include?("Mythical") }
        end
      end

      # Failsafe 2 (The Ultimate Fallback): If still empty, return the un-filtered base_theme pool or hardcoded fallback
      if filtered_pool.empty?
        return base_pool unless base_pool.empty?
        return FALLBACK_POOL
      end

      return filtered_pool
    end

    return FALLBACK_POOL
  end
end