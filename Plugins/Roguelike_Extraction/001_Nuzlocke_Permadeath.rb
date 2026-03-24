#===============================================================================
# Automated Permadeath (Nuzlocke) - Updated for Normal/Easy Modes
#===============================================================================

# Helper to check if the entire party is fainted (a complete wipe)
def pbAllFainted?
  return false if !$player || !$player.party || $player.party.empty?
  return $player.party.none? { |pkmn| pkmn && !pkmn.egg? && pkmn.hp > 0 }
end

# Hook into the end of battle phase
EventHandlers.add(:on_end_battle, :nuzlocke_permadeath,
  proc { |_decision, _canLose|
    next if !$player || !$player.party

    # If the ENTIRE party is fainted, DO NOT wipe them here.
    # Let `pbStartOver -> RoguelikeExtraction.blackout` handle the entire wipe logic
    # so that it can save the starter (and potentially 1 more in Easy Mode).
    # If it is a hardcore wipe, `wipe_pokemon_hardcore` will delete them all anyway.
    next if pbAllFainted?

    # Identify the last box in the PC
    graveyard_box_index = $PokemonStorage.maxBoxes - 1

    # Auto-name the last box to "Graveyard" if it isn't already
    if $PokemonStorage[graveyard_box_index].name != "Graveyard"
      $PokemonStorage[graveyard_box_index].name = "Graveyard"
    end

    # Iterate backwards through the party to avoid shifting index issues when removing
    party_size = $player.party.length
    (0...party_size).to_a.reverse.each do |i|
      pkmn = $player.party[i]
      # If the Pokémon is valid, fainted, and not an egg
      if pkmn && !pkmn.egg? && pkmn.hp <= 0
        placed = false

        # Start looking from the Graveyard box and spill over to previous boxes if full
        box_to_put = graveyard_box_index
        while box_to_put >= 0

          # Iterate slots in the current box
          $PokemonStorage[box_to_put].length.times do |slot|
            if $PokemonStorage[box_to_put][slot].nil?

              # If we are in Easy Mode (Switch 105), apply the black heart marking (bit 3) and cursed flag
              if $game_switches[105]
                pkmn.markings |= 8 # 8 is the 4th bit (0-indexed 3), which represents the Heart marking
                pkmn.is_cursed = true if pkmn.respond_to?(:is_cursed=)
              end

              # Store fainted pokemon in the box slot
              $PokemonStorage[box_to_put][slot] = pkmn

              # Auto-name spillover boxes if we end up using them
              if $PokemonStorage[box_to_put].name.empty? || $PokemonStorage[box_to_put].name.start_with?("Box")
                 $PokemonStorage[box_to_put].name = "Graveyard"
              end

              placed = true
              break
            end
          end

          break if placed
          box_to_put -= 1
        end

        # Remove from party
        $player.party.delete_at(i)
      end
    end

    # Compact the party to remove empty slots just in case
    $player.party.compact!
  }
)

# Auto-purge the Graveyard box(es) when the PC is accessed.
# We alias the main pbPokeCenterPC method to trigger the auto-purge
# right before the PC interface is actually loaded.
alias original_pbPokeCenterPC pbPokeCenterPC unless defined?(original_pbPokeCenterPC)
def pbPokeCenterPC
  # Auto-purge logic before PC opens
  # SKIP PURGE if Easy Mode (Switch 105) is ON
  if $PokemonStorage && !$game_switches[105]
    purged_any = false
    ($PokemonStorage.maxBoxes).times do |box_idx|
      if $PokemonStorage[box_idx].name == "Graveyard"
        $PokemonStorage[box_idx].length.times do |slot|
          if !$PokemonStorage[box_idx][slot].nil?
            $PokemonStorage[box_idx][slot] = nil # Release the fainted Pokémon
            purged_any = true
          end
        end
      end
    end

    if purged_any
      pbMessage(_INTL("The Graveyard has been purged."))
    end
  end

  # Call original PC logic
  original_pbPokeCenterPC
end
