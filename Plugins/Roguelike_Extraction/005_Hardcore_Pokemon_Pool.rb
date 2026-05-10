#===============================================================================
# Hardcore Starter Pool (Dynamic Generator - v21.1 Fix)
#===============================================================================

def pbChooseHardcorePokemon
  valid_starters = []

  GameData::Species.each do |species_data|
    # 1. Base forms only
    next if species_data.form != 0

    # NEW FIX: Check if the species is the lowest stage of its evolution family
    next if species_data.species != species_data.get_baby_species

    # 2. MUST be capable of evolving (Bans Legendaries, Togedemaru, Cryogonal)
    evolutions = species_data.get_evolutions
    next if evolutions.nil? || evolutions.empty?

    # 3. Foolproof BST Calculation
    bst = 0
    [:HP, :ATTACK, :DEFENSE, :SPECIAL_ATTACK, :SPECIAL_DEFENSE, :SPEED].each do |stat|
      bst += species_data.base_stats[stat] if species_data.base_stats[stat]
    end

    # 4. Strict BST ceiling and floor (Locked at 300 to 350)
    next if bst < 300
    next if bst > 350

    # If it passes all checks, add it to our draft pool!
    valid_starters.push(species_data.id)
  end

  # Return a random valid starter, with a true starter as the safety fallback
  return valid_starters.empty? ? :BULBASAUR : valid_starters.sample
end

def pbGiveHardcoreStarter
  species = pbChooseHardcorePokemon

  # pbGenerateWildPokemon acts as the factory, triggering all your custom hooks (like hue shifts!)
  pkmn = pbGenerateWildPokemon(species, 5)

  pbAddPokemon(pkmn)
end