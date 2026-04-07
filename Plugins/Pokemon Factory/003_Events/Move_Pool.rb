module ZBox
    #==============================================================================
    # Ejemplo de la opción move_pool.
    # Example of the move_pool option.
    #==============================================================================

    # Se puede llamar mediante un evento con: ZBox.give_mystery_pichu
    # Can be called from an event with: ZBox.give_mystery_pichu
    def self.give_mystery_pichu

      # Se crea la tabla de sorteo para decidir CUÁNTOS movimientos aprenderá de la move_pool.
      # A draw is made to decide HOW MANY moves will be learned from the move_pool.
      num_moves_to_learn = (rand(100) < 5) ? 2 : 1

      pichu_data = {
        species: :PICHU,
        level: 5,
        item: :LIGHTBALL,
        can_evolve: false,
        moves: [:THUNDERSHOCK],

        # Se usa la clave :move_pool.
        # The :move_pool key is used.
        move_pool: {
          # Define cuántos movimientos se seleccionarán del pool.
          # En este caso, hay un 5% de probabilidad de que sea 2, y un 95% de que sea 1.
          # Defines how many moves will be selected from the pool.
          # In this case, there is a 5% chance it will be 2, and a 95% chance it will be 1.
          learn_count: num_moves_to_learn,

          # Define la lista de movimientos disponibles y sus pesos de probabilidad relativos.
          # Defines the list of available moves and their relative probability weights.
          moves: [
            # [ :MOVIMIENTO, peso ]
            # [ :MOVE, weight ]
            [:SURF, 50],
            [:FLY,  50]
          ]
          # Como ambos pesos son iguales, Surf y Fly tienen la misma probabilidad (50/50) de ser elegidos.
          # Since both weights are equal, Surf and Fly have the same probability (50/50) of being chosen.
        }
      }

      pkmn = PokemonFactory.create(pichu_data)
      pbAddPokemon(pkmn)
    end
end