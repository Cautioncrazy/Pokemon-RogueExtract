module ZBox

    #==============================================================================
    # Ejemplo de type_chart_mods y type_chart_adds
    # Example of type_chart_mods and type_chart_adds
    #==============================================================================

    # --- Reemplazar la Tabla de Tipos ---
    # --- Replace the Type Chart ---

    # Se puede llamar mediante un evento con: ZBox.figth_golem
    # Can be called from an event with: ZBox.figth_golem
    def self.figth_golem
      golem_data = {
        species: :GOLEM,
        level: 100,

        # Los tipos que no entren en el hash se considerarán daño neutro.
        # Types that are not included in the hash will be considered neutral damage.
        type_chart_mods: {
          # Debilidad x6 a Agua y Planta
          # Weakness x6 to Water and Plant
          WATER: 6.0,
          GRASS: 6.0,


          # Resistencia x0.1 a Normal, Veneno y Fuego
          # Resistance x0.1 to Normal, Poison and Fire
          NORMAL: 0.1,
          POISON: 0.1,
          FIRE: 0.1,

          # Se coloca que es inmune a eléctrico porque se está sobreescribiendo su tabla de tipos original
          # It is stated that it is immune to electrical because its original type table is being overwritten.
          ELECTRIC: 0.0,

        }
      }

      pkmn = ZBox::PokemonFactory.create(golem_data)
      WildBattle.start(pkmn)
    end

    # --- Añadir a la Tabla de Tipos ---
    # --- Add the Type Chart ---

    # NOTA: ¡CUIDADO! SI SE AÑADE UN MULTIPLICADOR A UN TIPO AL CUAL EL POKÉMON YA POSEÉ UNO,
    # ESTE SE MULTIPLICARÁ POR ESE VALOR. POR LO QUE SI SE PONE "ICE: 2" A UN POKÉMON QUE POSEÉ
    # DEBILIDAD X4 A ESTE TIPO, ESTE SE MULTIPLICARÁ POR NUESTRO VALOR, SIENDO AHORA DEBIL X8 AL TIPO HIELO.

    # NOTE: CAUTION! IF YOU ADD A MULTIPLIER TO A TYPE THAT THE POKÉMON ALREADY HAS ONE TO,
    # IT WILL BE MULTIPLIED BY THAT VALUE. SO IF YOU ADD "ICE: 2" TO A POKÉMON THAT HAS
    # A 4X WEAKNESS TO THIS TYPE, IT WILL BE MULTIPLIED BY OUR VALUE, MAKING IT NOW 8X WEAK TO THE ICE TYPE.

    # Se puede llamar mediante un evento con: ZBox.figth_fat_snorlax
    # Can be called from an event with: ZBox.figth_fat_snorlax
    def self.figth_fat_snorlax
      snorlax_data = {
        species: :SNORLAX,
        level: 50,

        # En lugar de reemplazarlas, se añadirán las que el Pokémon ya posee.
        # Instead of replacing, the ones that the Pokémon already possesses will be added.
        type_chart_adds: {
          FIRE: 0.5,
          ICE: 0.5
        }
      }

      pkmn = ZBox::PokemonFactory.create(snorlax_data)
      WildBattle.start(pkmn)
    end
end
