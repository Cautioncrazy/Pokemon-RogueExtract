#===============================================================================
# DBK Factory Bridge
# Solves the conflict between ZBox::PokemonFactory overrides and DBK Wild Boss checks.
#===============================================================================

def pbFightFactoryBoss(boss_key)
  boss_data = ZBox::PokemonFactory.data[boss_key]

  if boss_data.nil?
    pbMessage(_INTL("Error: Could not find {1} in the Factory.", boss_key.to_s))
    return false
  end

  # 1. NATIVE BUILD (Bypass Engine Sanity Checks by building base first)
  species = boss_data[:species] || :BULBASAUR
  level = boss_data[:level] || 50
  pkmn = Pokemon.new(species, level)

  # 2. SAFE FACTORY OVERRIDES
  # Extract and apply attributes from the Factory hash manually to bypass engine sanity checks safely
  pkmn.name = boss_data[:nickname] if boss_data[:nickname]
  pkmn.item = boss_data[:item] if boss_data[:item]
  pkmn.poke_ball = boss_data[:poke_ball] if boss_data[:poke_ball]
  pkmn.shiny = true if boss_data[:shiny]
  pkmn.ability = boss_data[:ability] if boss_data[:ability]
  pkmn.nature = boss_data[:nature] if boss_data[:nature]

  if boss_data[:ivs] == :perfect
    GameData::Stat.each_main { |s| pkmn.iv[s.id] = 31 }
  elsif boss_data[:ivs].is_a?(Hash)
    boss_data[:ivs].each do |stat_key, stat_val|
      engine_key = GameData::Stat.get(stat_key).id rescue nil
      pkmn.iv[engine_key] = stat_val if engine_key
    end
  end

  if boss_data[:moves] && boss_data[:moves].is_a?(Array)
    pkmn.forget_all_moves
    boss_data[:moves].each { |m| pkmn.learn_move(m) }
  end

  pkmn.calc_stats
  pkmn.heal

  # 3. DBK BOSS FLAG INJECTION
  # Remove hallucinated setBattleRule("wildBoss") and use native DBK flags
  pkmn.immunities = [] if pkmn.immunities.nil?
  pkmn.immunities.push(:RAIDBOSS) unless pkmn.immunities.include?(:RAIDBOSS)

  # Set DBK HP Boss modifiers if needed (Alpha_DBK_Extension checks for hp_boost > 1)
  pkmn.hp_level = boss_data[:hp_level] || 3

  # 4. START ENCOUNTER
  pkmn.play_cry
  pbWait(0)

  setBattleRule("cannotRun")
  setBattleRule("databoxStyle", [:Long, "{1}"])

  outcome = WildBattle.start(pkmn)

  return (outcome == 1 || outcome == 4)
end
