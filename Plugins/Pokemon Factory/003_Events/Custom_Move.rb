# LAS OPCIONES DEBEN INTRODUCIRSE EXACTAMENTE COMO ESTÁN ESCRITAS
# THE OPTIONS MUST BE ENTERED EXACTLY AS WRITTEN

#==============================================================================
# Opciones para stat_changes: y stat_changes_target:
# Options for stat_changes: and stat_changes_target:
# :ATTACK
# :DEFENSE
# :SPECIAL_ATTACK
# :SPECIAL_DEFENSE
# :SPEED
# :ACCURACY
# :EVASION
#==============================================================================
# Opciones para apply_status_to_user: y apply_status_to_target:
# Options for apply_status_to_user: and apply_status_to_target:
# :SLEEP
# :POISON
# :BURN
# :PARALYSIS
# :FROZEN
# :ATTRACTION
# :FLINCH
#==============================================================================
# Opciones para target:
# Options for target:
# :NearFoe          (Un oponente cercano, a elegir) 
# :AllNearFoes      (Todos los oponentes cercanos)
# :Foe              (Un oponente cualquiera, incluso lejano)
# :AllFoes          (Todos los oponentes)
# :NearAlly         (Un aliado cercano)
# :UserOrNearAlly   (El usuario o un aliado cercano)
# :AllAllies        (Todos los aliados, sin incluir al usuario)
# :UserAndAllies    (El usuario y todos sus aliados)
# :NearOther        (Cualquier otro Pokémon cercano, a elegir)
# :AllNearOthers    (Todos los demás Pokémon cercanos)
# :Other            (Cualquier otro Pokémon, a elegir)
# :AllBattlers      (Todos los Pokémon en el campo)
# :User             (El propio usuario)
#==============================================================================
# Opciones para change_weather:
# Options for change_weather:
# :Sun	            Día Soleado	    
# :Rain	            Lluvia     
# :Sandstorm	      Tormenta Arena   
# :Hail	            Granizo	        
# :HarshSun	        Sol Abrasador   
# :HeavyRain	      Diluvio	        
# :StrongWinds	    Vientos Fuertes	
# :ShadowSky	      Cielo Sombrío	    
# :None	            Ninguno	        
#==============================================================================
# Opciones para change_terrain:
# Options for change_terrain:
# :Electric	        Campo Eléctrico	
# :Grassy	          Campo de Hierba	
# :Misty	          Campo de Niebla	
# :Psychic	        Campo Psíquico	
# :None	            Ninguno		
#==============================================================================
# Opciones para add_hazards_to_target_side:
# Options for add_hazards_to_target_side:
# :STEALTHROCK	    Trampa Rocas	
# :SPIKES	          Púas	
# :TOXICSPIKES	    Púas Tóxicas	
# :STICKYWEB	      Red Pegajosa	
#==============================================================================
# Opciones para add_side_effect_to_user:
# Options for add_side_effect_to_user:
# :TAILWIND	        Viento Afín	
# :REFLECT	        Reflejo
# :LIGHTSCREEN    	Pantalla de Luz
# :AURORAVEIL	      Velo Aurora	 
# :SAFEGUARD	      Velo Sagrado
# :MIST	   	        Neblina
#==============================================================================
# NOTA SOBRE heal_user:, heal_target:, fixed_damage_target: y recoil_user:
# NOTE ABOUT heal_user:, heal_target:, fixed_damage_target: and recoil_user:
#
# Si el valor que proporcionas es menor que 2 (ej. 0.5, 0.25), 
# el sistema lo tratará como un porcentaje del HP máximo.
# Si el valor es 2 o mayor (ej. 50, 100), 
# el sistema lo tratará como una cantidad fija de HP.
#
# If the value you provide is less than 2 (e.g., 0.5, 0.25),
# the system will treat it as a percentage of the maximum HP.
# If the value is 2 or greater (e.g., 50, 100),
# the system will treat it as a fixed amount of HP.
#==============================================================================

module ZBox
    #==============================================================================
    # Ejemplo de custom_moves:
    # Example of custom_moves:
    #==============================================================================
 
    # Se puede llamar mediante un evento con: ZBox.give_anomalous_tyranitar
    # Can be called from an event with: ZBox.give_anomalous_tyranitar
    def self.give_anomalous_tyranitar  
      
      titan_data = {
        species: :TYRANITAR,
        level: 85,
        nickname: "Anomaly",
        shiny: true,
        poke_ball: :DUSKBALL,
        item: :ASSAULTVEST,
        ivs: :perfect,
        base_stats: { atk: 204, spa: 4, spe: 121 },
        
        # --- Movimientos personalizados ---
        # --- Custom moves ---
        custom_moves: [
          # Un "Triturar" que se convierte en un ataque con prioridad y tiene su propio nombre.
          # A "Crunch" that becomes a priority attack and has its own name.
          {
            move: :CRUNCH,
            
            # Nombre personalizado.
            # Personalized name
            name: "Mordisco Abisal",  
            
            # Descripción personalizada.
            # Custom description.
            description: "Tritura de manera sorpresiva con afilados colmillos. Puede bajar la defensa.",  
            
            # Originalmente tiene 15
            # Originally it has 15
            total_pp: 10, 
            
            # Potencia ligeramente aumentada. 
            # Slightly increased power.
            power: 90,    
            
            # Actúa como un Ataque Rápido. 
            # Acts like Quick Attack.
            priority: 1   
          },
          
          # Un "Roca Afilada" que nunca falla.
          # A "Stone Edge" that never misses.
          {
            move: :STONEEDGE,
            
            # 0 o 101 significa que siempre acierta. 
            # 0 or 101 means it always hits.
            accuracy: 0,        
           
            power: 100
          },
          
          # Un "Terremoto" de tipo Siniestro 
          # A Dark-type "Earthquake" 
          {
            move: :EARTHQUAKE,

            # Cambia su tipo a Siniestro. 
            # Changes its type to Dark.
            type: :DARK,       
            
            power: 100,
          },
          
          # Un "Rayo Hielo" físico para usar su alto Ataque.
          # A physical "Ice Beam" to use its high Attack.
          {
            move: :ICEBEAM,
            
            # Ahora usa el Ataque Físico. 
            # Now uses Physical Attack.
            category: :PHYSICAL, 
            
            power: 90,
          }
        ]
      }
      
      pkmn = PokemonFactory.create(titan_data)
      pbAddPokemonWithNickname(pkmn)
    end

    #==============================================================================
    # Ejemplo de custom_moves: con moves:
    # Example of custom moves: with moves:
    #==============================================================================
    
    # Se puede llamar mediante un evento con: ZBox.give_pikachu_of_ash
    # Can be called from an event with: ZBox.give_pikachu_of_ash
    def self.give_pikachu_of_ash  
      
      pikachu_data = {
        species: :PIKACHU,
        level: 88,
        item: :LIGHTBALL,
        poke_ball: :POKEBALL,
        ivs: :perfect,
        evs: :sweeper_special,
        happiness: 255,
        owner_name: "Ash",
        
        # Se define el moveset sin el movimiento personalizado.
        # The moveset is defined without the custom move.
        moves: [:QUICKATTACK, :IRONTAIL, :ELECTROWEB],
        
        # --- Movimiento personalizado ---
        # --- Custom move ---
        custom_moves: [
          {
            move: :THUNDERSHOCK,
            name: "Atactrueno",
            description: "El Impactrueno más poderoso del mundo.",
            power: 110,
            accuracy: 0, 
            total_pp: 15,
          }
        ]
      }
      
      pkmn = PokemonFactory.create(pikachu_data)
      pbAddPokemonWithNickname(pkmn)
    end

    #==============================================================================
    # Ejemplo de status_effect: 
    # Example of status_effect:
    #==============================================================================

    # --- Movimientos que afectan al usuario ---
    # --- Movements that affect the user ---

    # Se puede llamar mediante un evento con: ZBox.give_berserker_dragonite
    # Can be called from an event with: ZBox.give_berserker_dragonite
    def self.give_berserker_dragonite  
      
      dragonite_data = {
        species: :DRAGONITE,
        level: 100,
        nickname: "Berserker",
        item: :LUMBERRY,
        ivs: :perfect,
        evs: :sweeper_physical,
        moves: [:DRAGONCLAW, :EXTREMESPEED, :ROOST],
        
        custom_moves: [
          {
            move: :DRAGONDANCE,
            name: "Ira Dragón",
            description: "Danza salvaje que sube mucho el Ataque y la Velocidad, pero baja las defensas.",
            
            
            status_effect: {
              # Mensaje que saldrá cuando use el movimiento. {1} es quien usa el movimiento
              # Message that will appear when you use the movement. {1} is the one who uses the movement
              message: "¡La furia de {1} se desata!",
              
              
              stat_changes: [
                [:ATTACK, 3],
                [:SPEED, 2],
                [:DEFENSE, -2],         
                [:SPECIAL_DEFENSE, -2]
              ],

            # apply_status_to_user: [:STATUS, PROBABILITY] 
              apply_status_to_user: [:CONFUSION, 30]   

            # Multiple Status
            # apply_status_to_user: [ [:CONFUSION, 30], [:PARALYSIS, 30] ]

            }
          }
        ]
      }
      
      pkmn = ZBox::PokemonFactory.create(dragonite_data)
      WildBattle.start(pkmn)
    end


    # --- Movimientos que afectan al oponente ---
    # --- Moves that affect the opponent ---

    # Se puede llamar mediante un evento con: ZBox.give_spooky_gengar
    # Can be called from an event with: ZBox.give_spooky_gengar   
    def self.give_spooky_gengar
      gengar_data = {
        species: :GENGAR,
        level: 100,
        moves: [:SHADOWBALL, :SLUDGEBOMB, :THUNDERBOLT],
        
        custom_moves: [
          {
            move: :SCARYFACE, 
            name: "Mirada Espectral",
            description: "Una mirada aterradora que baja las defensas. Puede paralizar y confundir.",
            type: :GHOST,
            
            # Objetivos a los que el movimiento afectará.:AllFoes es a todos los oponentes.
            # Targets that the move will affect.":AllFoes" refers to all opponents.
            target: :AllFoes,
            
            status_effect: {
              message: "¡{1} lanza una mirada aterradora!",

              stat_changes_target: [
                [:DEFENSE, -2],         
                [:SPECIAL_DEFENSE, -2]
              ],
              apply_status_to_target: [
                [:PARALYSIS, 30], 
                [:CONFUSION, 30]  
              ]
            }
          }
        ]
      }
      
      pkmn = ZBox::PokemonFactory.create(gengar_data)
      pbAddPokemon(pkmn)
    end

    # --- Movimientos para cambiar el clima ---
    # --- Movements to change the climate ---

    # Se puede llamar mediante un evento con: ZBox.give_drought_torkoal
    # Can be called from an event with: ZBox.give_drought_torkoal
    def self.give_drought_torkoal
      torkoal_data = {
        species: :TORKOAL,
        level: 100,
        custom_moves: [
          {
            move: :SUNNYDAY,
            name: "Sequía Súbita",
            description: "Provoca un sol abrasador que dura 8 turnos.",
            status_effect: {
              # Realmente no hay diferecia con message:
              # There's really no difference with message:
              message_user: "¡{1} expulsa una nube de ceniza que intensifica el sol!",
            
              # change_weather: [:WEATHER, DURATION]
              change_weather: [:Sun, 8]
            }
          }
        ]
      }
      pkmn = ZBox::PokemonFactory.create(torkoal_data)
      pbAddPokemon(pkmn)
    end

    # --- Movimientos para cambiar terrenos ---
    # --- Movements to change terrains ---

    # Se puede llamar mediante un evento con: ZBox.give_psy_gardevoir
    # Can be called from an event with: ZBox.give_psy_gardevoir
    def self.give_psy_gardevoir
      gardevoir_data = {
        species: :GARDEVOIR,
        level: 100,
        custom_moves: [
          {
            move: :CALMMIND,
            name: "Pulso Psiónico",
            description: "Emite una onda que crea un campo extraño y agudiza la mente.",
            status_effect: {
              message_user: "¡La mente de {1} se expandió, alterando el campo de batalla!",
              stat_changes: [[:SPECIAL_ATTACK, 1]],
              
            # change_terrain: [:TERRAIN, DURATION]
              change_terrain: [:Psychic, 10]
            }
          }
        ]
      }
      pkmn = ZBox::PokemonFactory.create(gardevoir_data)
      pbAddPokemon(pkmn)
    end

    # --- Movimientos para poner trampas ---
    # --- Movements to set traps ---

    # Se puede llamar mediante un evento con: ZBox.give_trapper_ariados
    # Can be called from an event with: ZBox.give_trapper_ariados
    def self.give_trapper_ariados
      ariados_data = {
        species: :ARIADOS,
        level: 100,
        custom_moves: [
          {
            move: :TOXICSPIKES,
            name: "Nido de Arañas",
            description: "Teje una compleja red de trampas venenosas y pegajosas.",
            status_effect: {
              message: "¡{1} ha tejido un nido de trampas en el campo rival!",
              
              # Pueden ser múltiples efectos
              # There can be multiple effects
              add_hazards_to_target_side: [
                { hazard: :TOXICSPIKES, message: "¡Púas impregnadas de veneno aparecieron bajo {1}!" },
                { hazard: :STICKYWEB,   message: "¡Una red pegajosa atrapa los pies de {1}!" }
              ]
            }
          }
        ]
      }
      pkmn = ZBox::PokemonFactory.create(ariados_data)
      pbAddPokemon(pkmn)
    end

    # --- Movimientos de soporte ---
    # --- Support movements ---

    # Se puede llamar mediante un evento con: ZBox.give_support_alcremie
    # Can be called from an event with: ZBox.give_support_alcremie
    def self.give_support_alcremie
      alcremie_data = {
        species: :ALCREMIE,
        level: 100,
    
        custom_moves: [
          {
            move: :DECORATE,
            name: "Fortaleza Glaseada",
            description: "Cubre al equipo con una barrera protectora dulce y resistente.",
            target: :UserAndAllies,
            status_effect: {
              message_user: "¡{1} cubrió a su equipo con un glaseado protector!",
             
              add_side_effect_to_user: [
                { effect: :REFLECT,     duration: 8, message: "¡Una barrera física protege a {1}!" },
                { effect: :LIGHTSCREEN, duration: 6, message: "¡Una barrera especial protege a {1}!" },
                { effect: :SAFEGUARD,   duration: 10, message: "¡Un velo dulce protege a {1} de problemas de estado!" }
              ]
            }
          }
        ]
      }
  
      pkmn = ZBox::PokemonFactory.create(alcremie_data)
      pbAddPokemon(pkmn)
    end

    # --- Movimiento que cura al usuario o genera daño de retroceso ---
    # --- Move that heals the user or deals recoil damage ---
    
    # Se puede llamar mediante un evento con: ZBox.give_sacrifice_gardevoir
    # Can be called from an event with: ZBox.give_sacrifice_gardevoir
    def self.give_sacrifice_gardevoir
      gardevoir_data = {
        species: :GARDEVOIR,
        level: 100,
        hp: 9,
        custom_moves: [
          {
            move: :CELEBRATE,
            name: "Sacrificio Vital",
            description: "Restaura todos los PS, pero el usuario sufre un gran daño a cambio.",
            status_effect: {
              message_user: "¡{1} canaliza su propia fuerza vital!",

              # El usuario recibe un 50% de su HP máximo como daño de recoil.
              # The user receives 50% of their maximum HP as recoil damage.
              recoil_user: 0.5,

              # Cura el 100% del HP máximo.
              # Heals 100% of maximum HP.
              heal_user: 1
              
            }
          }
        ]
      }
      pkmn = ZBox::PokemonFactory.create(gardevoir_data)
      pbAddPokemon(pkmn)
    end

    # --- Movimiento que cura a un objetivo ---
    # --- Movement that heals a target ---
    
    # Se puede llamar mediante un evento con: ZBox.give_healer_chansey
    # Can be called from an event with: ZBox.give_healer_chansey
    def self.give_healer_chansey
      chansey_data = {
        species: :CHANSEY,
        level: 100,
        custom_moves: [
          {
            move: :GROWL,
            target: :UserOrNearAlly,
            name: "Pulso Sanador",
            description: "Emite una onda calmante que restaura los PS de un aliado.",
            status_effect: {
              message: "¡{1} emite una onda sanadora!",
              
              # Cura al objetivo un 25% de su HP máximo.
              # Heals the target for 25% of their maximum HP.
              heal_target: 0.25
            }
          }
        ]
      }
      pkmn = ZBox::PokemonFactory.create(chansey_data)
      pbAddPokemon(pkmn)
    end

    # --- Movimiento que hace un daño fijo ---
    # --- Move that deals fixed damage --- ---

    # Se puede llamar mediante un evento con: ZBox.figth_dragon_charmander
    # Can be called from an event with: ZBox.figth_dragon_charmander
    def self.figth_dragon_charmander
      charmander_data = {
        species: :CHARMANDER,
        level: 20,
        custom_moves: [
          {
            move: :EMBER,
            name: "Flama Dragón",
            description: "Lanza una onda de choque que siempre inflige 40 PS de daño.",
            type: :DRAGON,           
            category: :SPECIAL,

            # La potencia es irrelevante, es para que salga como ???
            # The power is irrelevant, it's so it comes out like ???
            power: 1,
        
            status_effect: {
              message: "¡{1} lanza una onda de choque furiosa!",
              
              # Inflige 40 puntos de daño fijo al objetivo.
              # Inflicts 40 fixed damage to the target.
              fixed_damage_target: 40
            }
          }
        ]
      }
      pkmn = ZBox::PokemonFactory.create(charmander_data)
      WildBattle.start(pkmn)
    end


    # --- Movimiento que anular el ultimo usado, cambiar la habilidad o la desactiva.
    # --- Move that cancels the last one used, changes the ability, or deactivates it.

    # Se puede llamar mediante un evento con: ZBox.give_saboteur_sableye
    # Can be called from an event with: ZBox.give_saboteur_sableye
    def self.give_saboteur_sableye
      sableye_data = {
        species: :SABLEYE,
        level: 100,
    
        custom_moves: [
          {
            move: :CONFUSERAY,
            name: "Maleficio Total",
            description: "Un conjuro terrible que anula las capacidades del oponente.",
            type: :DARK,
            target: :NearFoe,
        
            status_effect: {
              message: "¡{1} lanza un maleficio terrible sobre el oponente!",
              # Suprime la habilidad.
              # Suppresses the ability.
              suppress_target_ability: true,

              # Cambia la habilidad a otra.
              # Change the ability to another one.
            # change_target_ability: :INTIMIDATE,
          
              # Desactiva el último movimiento por "x" turnos.
              # Deactivates the last move for "x" turns.
            # disable_target_last_move: 10,

              stat_changes_target: [
                [:DEFENSE, -1],
                [:SPECIAL_DEFENSE, -1]
              ],

              apply_status_to_target: [:CONFUSION, 100]
            }
          }
        ]
      }
  
      pkmn = ZBox::PokemonFactory.create(sableye_data)
      pbAddPokemon(pkmn)
    end
end   



