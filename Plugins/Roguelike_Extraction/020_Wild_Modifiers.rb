#===============================================================================
# Roguelike Wild Pokemon Modifiers (Difficulty & Megas)
#===============================================================================
EventHandlers.add(:on_wild_pokemon_created, :roguelike_wild_modifiers,
  proc { |pkmn|
    next if !$game_switches || !$game_switches[90] # ROGUELIKE_RUN_ACTIVE_SWITCH

    diff_setting = $game_variables[110] || 1 # 0 = Easy, 1 = Normal, 2 = Hard

    case diff_setting
    when 0 # Easy
      GameData::Stat.each_main { |s| pkmn.iv[s.id] = rand(10..15) }
      GameData::Stat.each_main { |s| pkmn.ev[s.id] = 0 }
    when 2 # Hard
      GameData::Stat.each_main { |s| pkmn.iv[s.id] = 31 }
      GameData::Stat.each_main { |s| pkmn.ev[s.id] = 252 }
    end

    pkmn.calc_stats
  }
)
