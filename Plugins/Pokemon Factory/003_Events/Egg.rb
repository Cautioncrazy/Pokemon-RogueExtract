module ZBox
    #==============================================================================
    # Ejemplo que de un huevo personalizado.
    # Example of a personalized egg.
    #==============================================================================

    
    # Se puede llamar mediante un evento con: ZBox.give_special_eevee_egg
    # Can be called from an event with: ZBox.give_special_eevee_egg
    def self.give_special_eevee_egg 
      
      # Definición del Hash de Configuración para el Huevo
      # Egg Configuration Hash Definition
      eevee_egg_config = {
        # No se necesita level:, pbGenerateEgg lo hace por nosotros.
        # level: are not needed, pbGenerateEgg does it for us.
        species: :EEVEE,
        
        # Cuantos pasos necesitará para eclosionar. Si no se pone, será el que ocupa el Pokémon por defecto.
        # How many steps it will need to hatch. If not set, it will be the Pokémon's default.
        steps_to_hatch: 1,  
        
        # Atributos Ocultos (Post-Eclosión) 
        # Hidden Attributes (Post-Hatch) 
        shiny: true,
        nature: :TIMID,
        ability_index: 2,
        ivs: :perfect, 
        
        # Datos de Origen. 
        # Origin Data.
        obtain_text: "Guardería Pokémon"
      }
      
      # Se llama a la EggFactory.
      # The EggFactory is called.
      if EggFactory.create(eevee_egg_config)
        # La fábrica ya muestra el mensaje "Obtuvo un Huevo", así que aquí podemos añadir un mensaje adicional si queremos.
        # The factory already shows the "Got an Egg" message, so here we can add an additional message if we want.
        pbMessage(_INTL("¡Cuida bien de él!"))
      else
        # La fábrica devuelve nil si el equipo está lleno.
        # The factory returns nil if the party is full.
        pbMessage(_INTL("¡Oh, parece que no tienes espacio en tu equipo!"))
      end
    end   
end    