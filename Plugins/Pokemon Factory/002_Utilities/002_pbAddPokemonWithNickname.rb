#==============================================================================
# Esta función es un pbAddPokemon pero se salta la pantalla de nombramiento.
# Es ideal para Pokémon de evento que ya tienen un apodo definido.
# Ahorrando tiempo en la necesidad de hacer todo un evento con pbAddPokemonSilent.
#==============================================================================
# This function is a pbAddPokemon but it skips the naming screen.
# It is ideal for event Pokémon that already have a defined nickname.
# Saving time from the need to make a whole event with pbAddPokemonSilent.
#==============================================================================
def pbAddPokemonWithNickname(pkmn, level = 1, see_form = true)
  return false if !pkmn
  if pbBoxesFull?
    pbMessage(_INTL("¡There is no space for more Pokémon!") + "\1")
    pbMessage(_INTL("¡The PC Boxes are full and have no more space!"))
    return false
  end
  pkmn = Pokemon.new(pkmn, level) if !pkmn.is_a?(Pokemon)
  species_name = pkmn.speciesName
  pbMessage(_INTL("¡\\c[2]{1}\\c[0] obtained \\c[5]{2}\\c[0] ({3})!", $player.name, pkmn.name, pkmn.speciesName) + "\\me[Pkmn get]\\wtnp[80]")
  was_owned = $player.owned?(pkmn.species)
  $player.pokedex.set_seen(pkmn.species)
  $player.pokedex.set_owned(pkmn.species)
  $player.pokedex.register(pkmn) if see_form
  # Show Pokédex entry for new species if it hasn't been owned before
  if Settings::SHOW_NEW_SPECIES_POKEDEX_ENTRY_MORE_OFTEN && see_form && !was_owned &&
     $player.has_pokedex && $player.pokedex.species_in_unlocked_dex?(pkmn.species)
    pbMessage(_INTL("Los datos de \\c[5]{1}\\c[0] se han añadido a la Pokédex.", species_name))
    $player.pokedex.register_last_seen(pkmn)
    pbFadeOutIn do
      scene = PokemonPokedexInfo_Scene.new
      screen = PokemonPokedexInfoScreen.new(scene)
      screen.pbDexEntry(pkmn.species)
    end
  end
  if $player.party_full?
    # Credits: dptierra
    cmds = [_INTL("Add to your party"),
          _INTL("Send to a Box"),
          _INTL("See the summary of {1}", pkmn.name),
          _INTL("Check party")]
    cmd = -1
    loop do
      cmd = pbMessage(_INTL("What do you want to do with \\c[5]{1}\\c[0]?", pkmn.name), cmds, -1)
      break if cmd == -1  # Cancelling = send to a Box

      case cmd
      when 0
        pbMessage(_INTL("Choose a Pokémon in your party to replace."))
        pbChoosePokemon(1, 2)
        next if $game_variables[1] == -1
        party_index = pbGet(1)
        next if party_index == nil

        send_pkmn = $player.party[party_index]
        $player.party[party_index] = pkmn

        stored_box = $PokemonStorage.pbStoreCaught(send_pkmn)
        box_name   = $PokemonStorage[stored_box].name

        pbMessage(_INTL("¡\\c[5]{1}\\c[0] has been sent to Box \"{2}\"!", send_pkmn.name, box_name))
        pbMessage(_INTL("¡\\c[5]{1}\\c[0] was added to your party!", pkmn.name))
        break
      when 1
        stored_box = $PokemonStorage.pbStoreCaught(pkmn)
        box_name   = $PokemonStorage[stored_box].name
        pbMessage(_INTL("¡\\c[5]{1}\\c[0] has been sent to Box \"{2}\"!", pkmn.name, box_name))
        break
      when 2   # See X's summary
      pbFadeOutIn do
        summary_scene = PokemonSummary_Scene.new
        summary_screen = PokemonSummaryScreen.new(summary_scene, true)
        summary_screen.pbStartScreen([pkmn], 0)
      end
      when 3   # Check party
        pbPokemonScreen
      end
    end
    if cmd == -1
      stored_box = $PokemonStorage.pbStoreCaught(pkmn)
      box_name   = $PokemonStorage[stored_box].name
      pbMessage(_INTL("¡\\c[5]{1}\\c[0] has been sent to Box \"{2}\"!", pkmn.name, box_name))
    end
  else
    pbMessage(_INTL("¡\\c[5]{1}\\c[0] joined the party!", pkmn.name))
    $player.party[$player.party.length] = pkmn
  end
  return true
end