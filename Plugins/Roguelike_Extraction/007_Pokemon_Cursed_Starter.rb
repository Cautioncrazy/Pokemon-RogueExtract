#===============================================================================
# Starter Tagging and Cursed Marking (Easy Mode)
#===============================================================================

class Pokemon
  attr_accessor :is_roguelike_starter
  attr_accessor :is_cursed

  alias roguelike_extraction_init initialize unless private_method_defined?(:roguelike_extraction_init)
  def initialize(*args)
    roguelike_extraction_init(*args)
    @is_roguelike_starter = false
    @is_cursed = false
  end

  def is_roguelike_starter?
    @is_roguelike_starter ||= false
    return @is_roguelike_starter
  end

  def is_cursed?
    @is_cursed ||= false
    return @is_cursed
  end
end

# Hook into pbAddPokemon to automatically tag the first pokemon
# the player receives as the starter.
alias original_pbAddPokemon pbAddPokemon unless defined?(original_pbAddPokemon)
def pbAddPokemon(*args)
  # Before adding, check if party and PC are completely empty
  is_first_pokemon = true

  if $player && $player.party.length > 0
    is_first_pokemon = false
  end

  if is_first_pokemon && $PokemonStorage
    ($PokemonStorage.maxBoxes).times do |box_idx|
      if !$PokemonStorage[box_idx].empty?
        is_first_pokemon = false
        break
      end
    end
  end

  # Perform original add
  result = original_pbAddPokemon(*args)

  # If it was successful and it was the first pokemon, find the newest pokemon
  # (which should be the last one in the party, since PC was empty)
  if result && is_first_pokemon && $player && $player.party.last
    $player.party.last.is_roguelike_starter = true
  end

  return result
end

# Hook into Nurse Joy's healing to skip cursed Pokemon
alias original_pbHealAll pbHealAll unless defined?(original_pbHealAll)
def pbHealAll(*args)
  return if !$player || !$player.party
  # Keep track of originally cursed Pokemon so we don't heal them
  cursed_indices = []
  $player.party.each_with_index do |pkmn, i|
    if pkmn && pkmn.is_cursed?
      cursed_indices.push(i)
    end
  end

  # Call the original pbHealAll
  original_pbHealAll(*args)

  # Revert cursed Pokemon back to 0 HP
  cursed_indices.each do |i|
    pkmn = $player.party[i]
    if pkmn
      pkmn.hp = 0
      # Ensure status is fainted if Essentials automatically cleared it
      pkmn.status = :NONE if pkmn.hp == 0
    end
  end
end

# Script Call to heal cursed Pokemon in the Hub
def pbHealCursedPokemon
  return false if !$player || !$player.party

  cursed_pokemon = $player.party.select { |pkmn| pkmn && pkmn.is_cursed? }
  if cursed_pokemon.empty?
    pbMessage(_INTL("You do not have any cursed Pokémon in your party."))
    return false
  end

  floor = $PokemonGlobal.last_raid_floor
  floor = 1 if floor < 1
  cost_per_mon = 200 * floor
  total_cost = cost_per_mon * cursed_pokemon.length

  if !pbConfirmMessage(_INTL("It will cost ${1} to revive your cursed Pokémon. Will you pay?", total_cost.to_s_formatted))
    return false
  end

  if $player.money < total_cost
    pbMessage(_INTL("You don't have enough money!"))
    return false
  end

  # Deduct money
  $player.money -= total_cost

  # Heal
  cursed_pokemon.each do |pkmn|
    pkmn.is_cursed = false
    pkmn.heal
    # Remove the heart marking (bit 3 / value 8) if it has it
    pkmn.markings &= ~8 if (pkmn.markings & 8) != 0
  end

  pbMessage(_INTL("Your cursed Pokémon have been fully revived!"))
  return true
end

# Block all items from being used on Cursed Pokemon
EventHandlers.add(:on_player_use_item_on_pokemon, :cursed_pokemon_block,
  proc { |item, qty, pkmn, scene|
    if pkmn.is_cursed?
      pbMessage(_INTL("{1} is cursed and cannot be healed with items!", pkmn.name))
      next false
    end
    next true
  }
)

# For compatibility with standard essentials ItemHandlers::CanUseInField
# We alias the core ItemHandlers trigger to hard-block cursed targets
module ItemHandlers
  class << self
    alias roguelike_extraction_triggerUseOnPokemon triggerUseOnPokemon unless method_defined?(:roguelike_extraction_triggerUseOnPokemon)
  end

  def self.triggerUseOnPokemon(item, qty, pkmn, scene, *args)
    if pkmn.is_cursed?
      pbMessage(_INTL("{1} is cursed and cannot be healed with items! Talk to Nurse Joy.", pkmn.name))
      return false
    end
    return roguelike_extraction_triggerUseOnPokemon(item, qty, pkmn, scene, *args)
  end
end
