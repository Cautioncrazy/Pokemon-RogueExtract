#===============================================================================
# Cursed Starter & Hardcore Wipe System Extensions
#===============================================================================

# 1. Pokemon Class Extensions
class Pokemon
  attr_writer :is_roguelike_starter
  attr_writer :is_cursed

  alias roguelike_extraction_init initialize unless private_method_defined?(:roguelike_extraction_init)
  def initialize(*args)
    roguelike_extraction_init(*args)
    @is_roguelike_starter = false
    @is_cursed = false
  end

  def is_roguelike_starter
    @is_roguelike_starter ||= false
    return @is_roguelike_starter
  end

  def is_cursed
    @is_cursed ||= false
    return @is_cursed
  end
end

# 2. Starter Tagging on First Add
alias roguelike_extraction_pbAddPokemon pbAddPokemon unless defined?(roguelike_extraction_pbAddPokemon)
def pbAddPokemon(*args)
  # Check if player has NO pokemon at all (empty party and empty PC)
  is_empty = true
  if $player && $player.party && !$player.party.empty?
    is_empty = false
  end

  if is_empty && $PokemonStorage
    ($PokemonStorage.maxBoxes).times do |box_idx|
      # In v21.1, Box length is tested differently or iterating slots is used.
      $PokemonStorage[box_idx].length.times do |slot|
        if !$PokemonStorage[box_idx][slot].nil?
          is_empty = false
          break
        end
      end
      break if !is_empty
    end
  end

  result = roguelike_extraction_pbAddPokemon(*args)

  if is_empty && result && $player && $player.party && !$player.party.empty?
    $player.party[0].is_roguelike_starter = true
  end

  return result
end

# 3. Cursed Pokemon Restrictions - Healing
alias roguelike_extraction_pbHealAll pbHealAll unless defined?(roguelike_extraction_pbHealAll)
def pbHealAll
  roguelike_extraction_pbHealAll

  # Loop back through and re-faint cursed pokemon
  if $player && $player.party
    $player.party.each do |pkmn|
      if pkmn && pkmn.is_cursed
        pkmn.hp = 0
        pkmn.status = :NONE
      end
    end
  end
end

# 4. Cursed Pokemon Restrictions - Items
module ItemHandlers
  class << self
    alias roguelike_extraction_triggerUseOnPokemon triggerUseOnPokemon unless method_defined?(:roguelike_extraction_triggerUseOnPokemon)

    def triggerUseOnPokemon(item, qty, pkmn, scene, *args)
      if pkmn && pkmn.is_cursed
        scene.pbDisplay(_INTL("This Pokémon is cursed and cannot be healed with items!")) if scene
        return false
      end
      return roguelike_extraction_triggerUseOnPokemon(item, qty, pkmn, scene, *args)
    end
  end
end

EventHandlers.add(:on_player_use_item_on_pokemon, :cursed_pokemon_block,
  proc { |item, pkmn, scene|
    if pkmn.is_cursed
      scene.pbDisplay(_INTL("This Pokémon is cursed and cannot be healed with items!")) if scene
      next false
    end
    next true
  }
)
