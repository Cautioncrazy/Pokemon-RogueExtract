#===============================================================================
# System 2: Data Core Gacha (Pokémon Factory Integration)
#===============================================================================

# Define standard gacha currency
GACHA_CURRENCY = :DATACORE_COMMON

def pbGachaRoll(currency = GACHA_CURRENCY)
  if !$bag.has?(currency, 1)
    pbMessage(_INTL("You do not have any {1}s to spend.", GameData::Item.get(currency).name))
    return false
  end

  if pbConfirmMessage(_INTL("Spend 1 {1} to synthesize a Data Core Pokémon?", GameData::Item.get(currency).name))

    # Create the Pokemon using ZBox Factory from dynamic YOUR_EVENTS.rb data
    if defined?(ZBox::PokemonFactory) && !ZBox::PokemonFactory.data.empty?
      chosen_key = ZBox::PokemonFactory.data.keys.sample
      chosen_data = ZBox::PokemonFactory.data[chosen_key]
      pkmn = ZBox::PokemonFactory.create(chosen_data)
    else
      pbMessage(_INTL("No Data Core signatures available. (Gacha Pool empty)"))
      return false
    end

    $bag.remove(currency, 1)

    # Visual/audio feedback for Gacha
    pbSEPlay("Pkmn get")
    pbMessage(_INTL("Synthesis Complete!\\nObtained {1}!", pkmn.name))

    # Attempt to add to the first 3 boxes in PC Storage
    # Unlocked Starters concept
    box_added = false
    # Check boxes 0, 1, 2 for space
    3.times do |i|
      next if i >= $PokemonStorage.maxBoxes
      # Check if there is a free slot in this box
      slot = $PokemonStorage.pbFirstFreePos(i)
      if slot
        idx = $PokemonStorage[i].pokemon.index(nil)
        if idx
          $PokemonStorage[i, idx] = pkmn
          box_added = true
          pbMessage(_INTL("{1} was transferred to Box {2}.", pkmn.name, $PokemonStorage[i].name))
          break
        end
      end
    end

    # If the first 3 boxes are full, fallback to default PC logic
    if !box_added
      pbStorePokemon(pkmn)
    end

    return true
  end

  return false
end