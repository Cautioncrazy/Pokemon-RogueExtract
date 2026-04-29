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
    :WATER      => [:TENTACOOL, :MAGIKARP, :POLIWAG, :GOLDEEN, :STARYU, :SLOWPOKE, :SHELLDER],
    :LAB        => [:VOLTORB, :MAGNEMITE, :PORYGON, :KOFFING, :GRIMER, :DITTO, :ELECTRODE]
  }

  def self.get_wild_pool(theme)
    theme_str = theme.to_s

    # If the theme has an underscore (e.g. cave_FIRE)
    if theme_str.include?('_')
      suffix_type = theme_str.split('_').last.upcase.to_sym

      # Bypass the base pool entirely and go straight to the global scan
      pool = GameData::Species.keys.select { |s| GameData::Species.get(s).types.include?(suffix_type) }

      # Exclude legendaries/mythicals
      if !pool.empty? && GameData::Species.get(pool.first).respond_to?(:flags)
        pool.reject! { |s| GameData::Species.get(s).flags.include?("Legendary") || GameData::Species.get(s).flags.include?("Mythical") }
      end

      return pool unless pool.empty?
    else
      # No underscore exists, return the base theme array from WILD_POOLS
      base_theme = theme_str.upcase.to_sym
      return WILD_POOLS[base_theme] if WILD_POOLS.has_key?(base_theme)
    end

    return FALLBACK_POOL
  end
end