#==============================================================================
# Evita que se pregunte por un apodo si un Pokémon salvaje capturado
# ya tiene uno personalizado por la Factory.
#
# Prevent it from asking for a nickname if a captured wild Pokémon
# already has one customized by the Factory.
#==============================================================================

class Battle  
  if method_defined?(:zbox_pbStorePokemon)
    alias_method :pbStorePokemon, :zbox_pbStorePokemon
  end

  alias_method :zbox_pbStorePokemon, :pbStorePokemon
  def pbStorePokemon(pkmn)
    # Nickname the Pokémon (unless it's a Shadow Pokémon)
    if !pkmn.shadowPokemon?
      pokemon_name = pkmn.instance_variable_get(:@name)
      
      if pokemon_name.nil? || pokemon_name.empty?
        return zbox_pbStorePokemon(pkmn)
      end

      if pkmn.name == pkmn.speciesName
        return zbox_pbStorePokemon(pkmn)
      end
    end
    
    # Store the Pokémon
    if pbPlayer.party_full? && (@sendToBoxes == 0 || @sendToBoxes == 2)   # Ask/must add to party
      cmds = [_INTL("Añadir al equipo"),
              _INTL("Enviarlo al PC"),
              _INTL("Ver los datos de {1}", pkmn.name),
              _INTL("Comprobar equipo")]
      cmds.delete_at(1) if @sendToBoxes == 2
      loop do
        cmd = pbShowCommands(_INTL("¿Qué quieres hacer con {1}?", pkmn.name), cmds, 99)
        next if cmd == 99 && @sendToBoxes == 2   # Can't cancel if must add to party
        break if cmd == 99   # Cancelling = send to a Box
        cmd += 1 if cmd >= 1 && @sendToBoxes == 2
        case cmd
        when 0   # Add to your party
          pbDisplay(_INTL("Elige un Pokémon de tu equipo para reemplazarlo."))
          party_index = -1
          @scene.pbPartyScreen(0, (@sendToBoxes != 2), 1) do |idxParty, _partyScene|
            party_index = idxParty
            next true
          end
          next if party_index < 0   # Cancelled
          party_size = pbPlayer.party.length
          # Get chosen Pokémon and clear battle-related conditions
          send_pkmn = pbPlayer.party[party_index]
          @peer.pbOnLeavingBattle(self, send_pkmn, @usedInBattle[0][party_index], true)
          send_pkmn.statusCount = 0 if send_pkmn.status == :POISON   # Bad poison becomes regular
          send_pkmn.makeUnmega
          send_pkmn.makeUnprimal
          # Send chosen Pokémon to storage
          send_pkmn = pbPlayer.party[party_index]
          stored_box = @peer.pbStorePokemon(pbPlayer, send_pkmn)
          pbPlayer.party.delete_at(party_index)
          box_name = @peer.pbBoxName(stored_box)
          pbDisplayPaused(_INTL("Has enviado a {1} a la Caja \"{2}\".", send_pkmn.name, box_name))
          # Rearrange all remembered properties of party Pokémon
          (party_index...party_size).each do |idx|
            if idx < party_size - 1
              @initialItems[0][idx] = @initialItems[0][idx + 1]
              $game_temp.party_levels_before_battle[idx] = $game_temp.party_levels_before_battle[idx + 1]
              $game_temp.party_critical_hits_dealt[idx] = $game_temp.party_critical_hits_dealt[idx + 1]
              $game_temp.party_direct_damage_taken[idx] = $game_temp.party_direct_damage_taken[idx + 1]
            else
              @initialItems[0][idx] = nil
              $game_temp.party_levels_before_battle[idx] = nil
              $game_temp.party_critical_hits_dealt[idx] = nil
              $game_temp.party_direct_damage_taken[idx] = nil
            end
          end
          break
        when 1   # Send to a Box
          break
        when 2   # See X's summary
          pbFadeOutIn do
            summary_scene = PokemonSummary_Scene.new
            summary_screen = PokemonSummaryScreen.new(summary_scene, true)
            summary_screen.pbStartScreen([pkmn], 0)
          end
        when 3   # Check party
          @scene.pbPartyScreen(0, true, 2)
        end
      end
    end
    # Store as normal (add to party if there's space, or send to a Box if not)
    stored_box = @peer.pbStorePokemon(pbPlayer, pkmn)
    if stored_box < 0
      pbDisplayPaused(_INTL("{1} se ha añadido a tu equipo.", pkmn.name))
      @initialItems[0][pbPlayer.party.length - 1] = pkmn.item_id if @initialItems
      return
    end
    # Messages saying the Pokémon was stored in a PC box
    box_name = @peer.pbBoxName(stored_box)
    pbDisplayPaused(_INTL("¡{1} se ha enviado a la Caja \"{2}\"!", pkmn.name, box_name))
  end
end