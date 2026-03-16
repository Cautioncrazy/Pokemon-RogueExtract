#===============================================================================
# Automated Permadeath (Nuzlocke) - Initial Draft for v21.1
#===============================================================================

# Hook into the end of battle phase
EventHandlers.add(:on_end_battle, :nuzlocke_permadeath,
  proc { |_decision, _canLose|
    # $player is standard for v21.1 instead of $Trainer in many cases, but $player.party is typical
    next if !$player || !$player.party

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
          # Use standard pbStoreCaught logic or manually find free slot
          # Manual slot assignment gives us more control over exactly which box
          # `pbGetFreeSpace(box)` or similar might exist, but we can do it directly:

          # Iterate slots in the current box
          $PokemonStorage[box_to_put].length.times do |slot|
            if $PokemonStorage[box_to_put][slot].nil?
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
# Hooking into the start of the PC access.
EventHandlers.add(:on_enter_map, :auto_purge_graveyard_safeguard,
  proc { |_old_map_id|
    # A safe fallback hook: when entering a map, clean up any Graveyard boxes.
    next if !$PokemonStorage

    ($PokemonStorage.maxBoxes).times do |box_idx|
      if $PokemonStorage[box_idx].name == "Graveyard"
        $PokemonStorage[box_idx].length.times do |slot|
          $PokemonStorage[box_idx][slot] = nil # Release the fainted Pokémon
        end
      end
    end
  }
)

# You can also hook into standard PC access if a standard event handler exists for it,
# but using `on_enter_map` or aliasing `pbPokeCenterPC` ensures it gets purged regularly.
