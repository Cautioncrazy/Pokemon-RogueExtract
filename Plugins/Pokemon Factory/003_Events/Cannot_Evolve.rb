module ZBox
    #==============================================================================
    # Ejemplo que muestra la capacidad de usar las estadísticas base de algún  
    # Pokémon y dar la opción de no poder evolucionar.
    # Example showing the ability to use a Pokémon's base stats and give the  
    # option to not be able to evolve.
    #==============================================================================

    def self.give_alpha_growlithe # Se puede llamar mediante un evento con: ZBox.give_alpha_growlithe / # Can be called from an event with: ZBox.give_alpha_growlithe
      
      # Se obtienen las estadísticas de Arcanine para usarlas como base.
      # Arcanine's stats are obtained to be used as a base.
      arcanine_stats = GameData::Species.get(:ARCANINE).base_stats

      # Se crea el hash de estadísticas modificadas.
      # The hash of modified stats is created.
      alpha_stats = {
        hp:      arcanine_stats[:HP] + 15,
        attack:  arcanine_stats[:ATTACK] + 15,
        defense: arcanine_stats[:DEFENSE] + 15,
        spatk:   arcanine_stats[:SPECIAL_ATTACK] + 15,
        spdef:   arcanine_stats[:SPECIAL_DEFENSE] + 15,
        speed:   arcanine_stats[:SPEED] + 15
      }

      # Definición del Hash de Configuración
      # Configuration Hash Definition
      growlithe_data = {
        species: :GROWLITHE,
        level: 50,
        nickname: "Alfa",
        shiny: true,
  
        # --- Modificadores Especiales ---
        # --- Special Modifiers ---

        # Usa el grito de Arcanine.
        # Uses Arcanine's cry.
        cry: "Cries/ARCANINE", 
        
        # Usa las estadísticas mejoradas. 
        # Uses the improved stats. 
        base_stats: alpha_stats,

        # No puede evolucionar. 
        # Cannot evolve.
        can_evolve: false,
  
        ivs: :perfect,
        evs: :sweeper_physical,
        moves: [:FLAREBLITZ, :EXTREMESPEED, :WILDCHARGE, :CLOSECOMBAT]
      }

      pkmn = PokemonFactory.create(growlithe_data)
      pbChooseWildPokemonByVersion(pkmn)
    end     
end    