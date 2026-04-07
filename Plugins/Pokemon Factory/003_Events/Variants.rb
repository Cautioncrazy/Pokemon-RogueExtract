module ZBox
    #==============================================================================
    # Ejemplo de variants: para entregar distintos pokémon.
    # Example of variants: to deliver different Pokémon.
    #------------------------------------------------------------------------------
    #
    # No es necesario que los weight: sumen 100. El script ya se encarga de crear 
    # las probabilidades en base a la suma de los weight:.
    # The weights: do not need to add up to 100; the script already takes care 
    # of creating the probabilities based on the sum of the weights:.
    #==============================================================================

    # Se puede llamar mediante un evento con: ZBox.give_regional_bird 
    # Can be called from an event with: ZBox.give_regional_bird
    def self.give_regional_bird  
      
      bird_data = {
        # --- Atributos Comunes ---
        # --- Common Attributes ---

        # Todos los Pokémon entregados por este evento serán de nivel 15.
        # All Pokémon given by this event will be level 15.
        level: 15,
        
        # --- Definición de las Variantes ---
        # --- Variant Definition ---
        variants: [
          # --- Variantes Base (Siempre disponibles) ---
          # --- Base Variants (Always available) ---
          
          # Variante 1: Pidgey (Peso 40)
          # Variant 1: Pidgey (Weight 40)
          { weight: 40,
            config: { species: :PIDGEY, 
                      nature: :JOLLY 
            }
          },
          # Variante 2: Spearow (Peso 30)
          # Variant 2: Spearow (Weight 30)
          { weight: 30,
            config: { species: :SPEAROW, 
                      nature: :ADAMANT 
            }
          },
          # Variante 3: Hoothoot (Peso 30)
          # Variant 3: Hoothoot (Weight 30)
          { weight: 30,
            config: { species: :HOOTHOOT, 
                      nature: :CALM 
            }
          },
          
          # --- Variantes Condicionales (Dependen del estado del juego) ---
          # --- Conditional Variants (Depend on the game's state) ---
          
          # Variante 4: Taillow (Solo si la Variable 40 es igual o mayor a 1)
          # Variant 4: Taillow (Only if Variable 40 is equal to or greater than 1)
          
          # Tiene un peso alto, pero solo se considerará si la condición se cumple.
          # It has a high weight, but will only be considered if the condition is met.
          { weight: 50,             
            condition: proc { $game_variables[40] >= 1 },
            config: {
              species: :TAILLOW,
              ability_index: 1, 
              moves: [:WINGATTACK, :QUICKATTACK, :FOCUSENERGY, :AERIALACE]
            }
          },
          
          # Variante 5: Starly (Solo si la Variable 40 es igual a 2)
          # Variant 5: Starly (Only if Variable 40 is equal to 2)
          { weight: 50,
            condition: proc { $game_variables[40] == 2 },
            config: {
              species: :STARLY,
              ability_index: 1, 
              moves: [:WINGATTACK, :QUICKATTACK, :ENDEAVOR, :AERIALACE]
            }
          },
          
          # Variante 6: Fletchling Shiny (Solo si el Interruptor 12 está ON)
          # Variant 6: Shiny Fletchling (Only if Switch 12 is ON)
          { weight: 20,
            condition: proc { $game_switches[12] },
            config: {
              species: :FLETCHLING,
              shiny: true,
              ability_index: 1,
              moves: [:PECK, :QUICKATTACK, :FLAIL, :ACROBATICS]
            }
          }
        ]
      }
      
      pkmn = PokemonFactory.create(bird_data)
      pbAddPokemon(pkmn)
    end


    #==============================================================================
    # Ejemplo de variants: para entregar un mismo Pokémon con distintas variantes.
    # Example of variants: to deliver the same Pokémon with different variants.
    #==============================================================================

    # Se puede llamar mediante un evento con: ZBox.give_multibuild_arcanine
    # Can be called from an event with: ZBox.give_multibuild_arcanine
    def self.give_multibuild_arcanine  
      
      arcanine_data = {
        # Todas las variantes compartirán estos atributos.
        # All variants will share these attributes.
        species: :ARCANINE,
        level: 50,
        shiny: true,
        poke_ball: :FASTBALL,
        ivs: :perfect, 
        
        # --- Definición de las Variantes ---
        # --- Variant Definition ---
        variants: [
          # --- Variante 1: Atacante Físico (Peso 40) ---
          # --- Variant 1: Physical Attacker (Weight 40) ---
          { weight: 40,
            config: {
              nickname: "Blaze",
              nature: :ADAMANT,
              ability: :INTIMIDATE,
              item: :LIFEORB,
              evs: :sweeper_physical, # 252 Atk, 252 Spe, 4 HP
              moves: [:FLAREBLITZ, :EXTREMESPEED, :WILDCHARGE, :CLOSECOMBAT]
            }
          },
          
          # --- Variante 2: Atacante Especial (Peso 40) ---
          # --- Variant 2: Special Attacker (Weight 40) ---
          { weight: 40,
            config: {
              nickname: "Inferno",
              nature: :TIMID,
              ability: :FLASHFIRE,
              item: :CHOICESPECS,
              evs: :sweeper_special, # 252 SpA, 252 Spe, 4 HP
              moves: [:FLAMETHROWER, :DRAGONPULSE, :SCORCHINGSANDS, :EXTREMESPEED]
            }
          },
          
          # --- Variante 3: Tanque Defensivo (Peso 20) ---
          # --- Variant 3: Defensive Tank (Weight 20) ---
          { weight: 20,
            config: {
              nickname: "Guardian",
              nature: :IMPISH,
              ability: :INTIMIDATE,
              item: :HEAVYDUTYBOOTS,
              evs: :tank_physical, # 252 HP, 252 Def, 4 SpD
              moves: [:FLAREBLITZ, :WILLOWISP, :MORNINGSUN, :TELEPORT]
            }
          }
        ]
      }
      
      pkmn = PokemonFactory.create(arcanine_data)
      pbAddPokemonWithNickname(pkmn)
    end


    #==============================================================================
    # Ejemplo de variants: para entregar un huevo.
    # Example of variants: to deliver an egg.
    #==============================================================================
    
    # Se puede llamar mediante un evento con: ZBox.give_fossil_egg
    # Can be called from an event with: ZBox.give_fossil_egg
    def self.give_fossil_egg  
      
      fossil_egg_data = {

        # Todas las variantes compartirán estos atributos.
        # All variants will share these attributes.
        steps_to_hatch: 1,
        obtain_method: 1, 
        obtain_text: "Museo de la Ciencia",
        poke_ball: :POKEBALL,
        
        # --- Definición de las Variantes (lo que saldrá del huevo) ---
        # --- Variant Definition (what will hatch from the egg) ---
        variants: [
          # --- Variante 1: Omanyte (Común, Peso 45) ---
          # --- Variant 1: Omanyte (Common, Weight 45) ---
          { weight: 45,
            config: {
              species: :OMANYTE,
              nature: :MODEST,
              moves: [:CONSTRICT, :WITHDRAW] 
            }
          },
          
          # --- Variante 2: Kabuto (Común, Peso 45) ---
          # --- Variant 2: Kabuto (Common, Weight 45) ---
          { weight: 45,
            config: {
              species: :KABUTO,
              nature: :ADAMANT,
              moves: [:SCRATCH, :HARDEN]
            }
          },
          
          # --- Variante 3: Aerodactyl (Raro, Peso 10) ---
          # --- Variant 3: Aerodactyl (Rare, Weight 10) ---
          { weight: 10,
            config: {
              species: :AERODACTYL,
              shiny: true, 
              nature: :JOLLY,
              ability_index: 2, 
              moves: [:WINGATTACK, :SUPERSONIC, :BITE]
            }
          }
        ]
      }
      
      if EggFactory.create(fossil_egg_data)
        pbMessage(_INTL("¡¿Me pregunto qué saldrá de él...?!"))
      else
        pbMessage(_INTL("¡Oh, parece que no tienes espacio en tu equipo para el huevo!"))
      end
    end 
end    