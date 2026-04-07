module ZBox

    #==============================================================================
    # Ejemplo de base_stats y add_stats 
    # Example of base_stats and add_stats 
    #==============================================================================
    
    # Se puede llamar mediante un evento con: ZBox.give_glitched_porygon
    # Can be called from an event with: ZBox.give_glitched_porygon
    def self.give_glitched_porygon
      porygon_data = {
        species: :PORYGON,
        level: 25,
        nickname: "P0ryg0n_err",
        nature: :SERIOUS,
        ivs: :zero,
        hue_change: 180,
        
        # Incluso evolucionando o cambiando de forma, las estadísticas serán las mismas.
        # Ideal para pokémon que no evolucionan, están en su etapa final o no tienen cambio de forma.
        
        # Even if it evolves or changes form, the statistics will be the same.
        # Ideal for Pokémon that do not evolve, are in their final stage, or do not have a form change.
        base_stats: {
          hp: 30,
          attack: 30,
          defense: 30,
          special_attack: 150,
          special_defense: 30,
          speed: 150
        },
    
        moves: [:TRIATTACK, :DISCHARGE, :RECOVER, :SIGNALBEAM]
      }
  
      pkmn = ZBox::PokemonFactory.create(porygon_data)
      pbAddPokemonWithNickname(pkmn)
    end

    # Se puede llamar mediante un evento con: ZBox.give_lineage_eevee
    # Can be called from an event with: ZBox.give_lineage_eevee
    def self.give_lineage_eevee
      eevee_data = {
        species: :EEVEE,
        level: 100,
        nickname: "Noble Heart",
        shiny: true,
        item: :SILKSCARF,
        nature: :SERIOUS,
        ivs: :zero,
    
        # Estas estadísticas se suman o restan a las del pokémon. 
        # Manteniendo esa variación incluso cuando evoluciona o cambia de forma.

        # These stats are added to or subtracted from the Pokémon's stats. 
        # This variation remains even when it evolves or changes form.
        add_stats: {
          hp: 30,
          attack: 30,
          defense: -15,
          special_attack: 30,
          special_defense: -15,
          speed: 20
        },
    
        moves: [:QUICKATTACK, :TAILWHIP, :BITE]
      }
  
      pkmn = ZBox::PokemonFactory.create(eevee_data)
      pbAddPokemon(pkmn)
    end
end   



