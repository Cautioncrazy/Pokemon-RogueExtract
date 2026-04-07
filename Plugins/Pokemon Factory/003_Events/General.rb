module ZBox
    # Puedes poner el nombre que sea siempre que incie con "self." y el nombre sea separado con "_" si es necesario.
    # Para llamarlos mediante un evento, se usa ZBox.(nombre sin el self.). Revisar los de ejemplo.
    # You can use any name as long as it starts with "self." and the name is separated with "_" if necessary.
    # To call them via an event, use ZBox.(name without the self.). Review the examples.

    #==============================================================================
    # Ejemplo mostrando casi todas las configuraciones aplicables.
    # Example showing almost all applicable settings.
    #==============================================================================

    # Se puede llamar mediante un evento con: ZBox.give_abyssal_guardian
    # Can be called from an event with: ZBox.give_abyssal_guardian
    def self.give_abyssal_guardian

      # --- Definición del Hash de Configuración Completo ---
      # --- Full Configuration Hash Definition ---
      guardian_data = {

        # --- Atributos Básicos ---
        # --- Basic Attributes ---

        # Nombre interno del Pokémon.
        # Internal name of the Pokémon.
        species: :CORVIKNIGHT,

        # Nivel.
        # Level.
        level: 75,

        # Nombre que tendrá el Pokémon.
        # Name the Pokémon will have.
        nickname: "Abyss Wing",

        # Genero del Pokémon.
        # Gender of the Pokémon.
        gender: "male",

        # Si no existe alguna forma, carga la forma base.
        # If a form doesn't exist, it loads the base form.
      # form: 1,

        # Si es Shiny.
        # If it is Shiny.
        shiny: true,

        # Si es un SuperShiny.
        # If it is a SuperShiny.
      # super_shiny: true,

        # Pokeball en la que viene(Usar su nombre interno).
        # Pokeball it comes in (Use its internal name).
        poke_ball: :HEAVYBALL,

        # Un ID personal fijo.
        # A fixed personal ID.
      # personal_id: 1234567890,


        # --- Atributos de Combate ---
        # --- Combat Attributes ---

        # Habilidad que tendrá(Dentro de las que puede poseer).
        # Ability it will have (From those it can possess).
      # ability_index: 1,

        # Habilidad que tendrá(Aunque no pertenezca a su especie).
        # Ability it will have (Even if it doesn't belong to its species).
        ability: :MIRRORARMOR,

        # Naturaleza del Pokémon.
        # Nature of the Pokémon.
        nature: :ADAMANT,

        # Poder Oculto de cualquier tipo sin importar IVs.
        # Hidden Power of any type regardless of IVs.
        hidden_power: :BUG,

        # Objeto con el que vendrá.
        # Item it will come with.
        item: :LEFTOVERS,

        # Borra los movimientos que aprende en los niveles anteriores al de su obtención. Debe ser false para que se active
        # # Deletes the moves you learn in the levels prior to the one you obtained them. Must be false to activate
      # reset_moves: false,

        # Moveset (Se rellena con los que aprende por nivel si no se definen 4 y no se incluye reset_moves:)
        # Moveset (It is filled with what it learns per level if 4 are not defined and "reset_moves:" is not included)
        moves: [:IRONHEAD, :BRAVEBIRD, :BODYPRESS, :ROOST],

        # Movimientos que puede recordar.
        # Moves it can remember.
        first_moves: [:PECK, :LEER],

        # HP con el que se recibe al Pokémon.
        # HP the Pokémon is received with.
      # hp: 1,

        # Experiencia que tendrá el Pokémon. Esto sobrescribe al nivel asignado.
        # Experience the Pokémon will have. This overwrites the assigned level.
      # exp: 5500,

        # Cry personalizado(La ruta debe ser relativa a "Audio/SE/" del proyecto).
        # Custom Cry (The path must be relative to the project's "Audio/SE/").
        cry: "Cries/PIKACHU",

        # --- IVs y EVs ---

        # Usando Preset.
        # Using Preset.
      # ivs: :perfect,

        # De forma Manual.
        # Manually.
        ivs: { hp: 31, attack: 31, def: 31, spa: 31, spd: 31, spe: 31 },

        # Usando Preset.
        # Using Preset.
      # evs: :tank_physical, # Usando Preset. / Using Preset.

        # De forma Manual.
        # Manually.
        evs: { hp: 252, def: 252, spe: 4 },


        # --- Atributos de Origen y Propiedad ---
        # --- Origin and Ownership Attributes ---

        # Entrenador Original.
        # Original Trainer.
        owner_name: "Zik",

        # Genereno del entrenador.
        # Trainer's gender.
        owner_gender: 0,

        # 2 = Inglés.
        # 2 = English.
        owner_language: 2,

        # Se le asignará un ID aleatorio que no es el del jugador
        # A random ID that is not the player's will be assigned
      # owner_foreign: true

        # Establece como ID el numero dado
        # Sets the given number as the ID
        owner_foreign: 23256,

        # Nivel en el que fue obtenido.
        # Level at which it was obtained.
        obtain_level: 70,

        # Mapa en el que se obtuvo.
        # Map where it was obtained.
      # obtain_map: 42,

        # Texto sobre su obtención(En lugar del mapa de obtención).
        # Text about its obtention (Instead of the obtention map).
        obtain_text: "En el pico de una montaña ancestral.",

        # Tipo de obtención.
        # Obtention method.
        obtain_method: 4,

        # Fecha en la que se obtuvo(En este caso será la hora actual de tu sistema).
        # Date it was obtained (In this case, it will be your system's current time).
      # time_received: Time.now.to_i

        # Fecha personalizada en la que se obtuvo: Time.new(año, mes, día, hora, minuto, segundo).
        # Custom date it was obtained: Time.new(year, month, day, hour, minute, second).
        time_received: Time.new(2023, 12, 25, 10, 30, 0).to_i,


        # --- Atributos de Estado y Misceláneos ---
        # --- Status and Miscellaneous Attributes ---

        # Felicidad del Pokémon(De 0 a 255).
        # Pokémon's happiness (From 0 to 255).
        happiness: 255,

        # Cintas con las que viene.
        # Ribbons it comes with.
        ribbons: [:WORLDCHAMPION],

        # Marcas alternas: ●, ▲, ■, ♥, ★, ♦.
        # Alternating marks: ●, ▲, ■, ♥, ★, ♦.
        markings: [0, 1, 3, 1, 0, 2],

        # Se infecta con una cepa y duración aleatorias.
        # Infects with a random strain and duration.
     #  pokerus: true

        # Se infecta con la cepa 4(Cepas de 1 a 15).
        # Infects with strain 4 (Strains from 1 to 15).
        pokerus: 4,


        # --- Atributos de Huevo (si declaramos obtain_method: 1) ---
        # --- Egg Attributes (if we declare obtain_method: 1) ---

        # Mapa donde eclosionó.
        # Map where it hatched.
     #  hatched_map: 1,

        # Cuando eclosionó(Mismo formato que con time_received:).
        # When it hatched (Same format as with time_received:).
     #  time_egg_hatched: Time.new(2023, 12, 25, 10, 30, 0).to_i,

        # --- Estadísticas de Concurso ---
        # --- Contest Stats ---
        contest_stats: { cool: 100, beauty: 50, cute: 10, smart: 80, tough: 120 },

        # --- Restricciones ---
        # --- Restrictions ---

        # No se puede liberar, intercambiar ni depositar en el PC(Puede ser una o varias opciones).
        # Cannot be released, traded, or deposited on the PC (May be one or more options)
        discardable: [:release, :trade, :store],

        # --- Pokémon Especiales ---
        # --- Special Pokémon ---

        # Si fuera un Pokémon Oscuro
        # If it were a Shadow Pokémon
      # shadow: true,

        # Si estuviera fusionado
        # If it were fused
      # fused: pkmn2,


        # --- Modificaciones Base ---
        # --- Base Modifications ---

        # Personaliza los tipos del Pokémon
        # Customizes the Pokémon's types
        types: [:STEEL, :GHOST],

        # Personaliza sus estadisticas base
        # Customizes its base stats
        base_stats: { hp: 255, atk: 255, def: 255 }
      }

      # --- Creación y Entrega ---
      # --- Creation and Delivery ---

      # Creamos al Pokémon y lo guardamos en "pkmn"
      # We create the Pokémon and save it in "pkmn"
      pkmn = PokemonFactory.create(guardian_data)

      # En caso de quieras que el HP sea un porcentaje en vez de un valor fijo, hay que aplicarlo una vez creado el Pokémon.
      # In case you want the HP to be a percentage instead of a fixed value, you have to apply it once the Pokémon is created.
      pkmn.hp = (pkmn.totalhp / 2).floor

      # Método para entregar un Pokémon, pero omitinedo ponerle un nombre.
      # Method to give a Pokémon, but skipping the naming part.
      pbAddPokemonWithNickname(pkmn)
    end
end