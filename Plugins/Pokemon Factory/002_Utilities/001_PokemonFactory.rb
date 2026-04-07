#==============================================================================
# Pokemon Factory
#
# Autor / Author: Zik
#==============================================================================
# Proporciona una "fábrica" para la creación de Pokémon personalizados
# de una manera declarativa, flexible y centralizada.
#==============================================================================
# Provides a "factory" for creating custom Pokémon in a declarative,
# flexible, and centralized way.
#==============================================================================

module ZBox
  #==============================================================================
  # ** Egg Factory **
  #------------------------------------------------------------------------------
  # Proporciona una fábrica para la creación y personalización de Huevos Pokémon.
  #==============================================================================
  # Provides a factory for creating and customizing Pokémon Eggs.
  #==============================================================================

  module EggFactory
    def self.create(config_hash)

      # Procesar las variantes PRIMERO para determinar la configuración final.
      # Process the variants FIRST to determine the final configuration.
      final_config = config_hash
      if config_hash[:variants]
        # Se llama al método de la PokémonFactory para que haga el sorteo.
        # The PokémonFactory's method is called to perform the draw.
        variant_config = ZBox::PokemonFactory.send(:process_variants, config_hash[:variants])
        if variant_config
          # Se fusionan los hashes. La configuración de la variante tiene prioridad.
          # The hashes are merged. The variant's configuration has priority.
          final_config = config_hash.merge(variant_config)
        end
      end

      # Extraer la especie del hash de configuración final.
      # Extract the species from the final configuration hash.
      species = final_config[:species]
      # Si no se encuentra una especie (lo que sería un error de configuración), se aborta de forma segura.
      # If no species is found (which would be a configuration error), it aborts safely.
      return nil unless species

      # Se extrae el valor de steps_to_hatch del hash. Si no se proporciona, se usará el valor por defecto del motor.
      # Extracts the steps_to_hatch value from the hash. If not provided, the engine's default value will be used.
      custom_steps = final_config[:steps_to_hatch]

      # Se genera el huevo. pbGenerateEgg establecerá los pasos por defecto.
      # The egg is generated. pbGenerateEgg will set the default steps.
      egg_added = pbGenerateEgg(species, final_config[:obtain_text])
      return nil unless egg_added

      # Se obtiene una referencia al huevo.
      # A reference to the egg is obtained.
      egg = $player.last_party

      # Si se proporcionó un número de pasos personalizado, se sobrescribe el valor por defecto que puso pbGenerateEgg.
      # If a custom number of steps was provided, it overwrites the default value set by pbGenerateEgg.
      egg.steps_to_hatch = custom_steps if custom_steps

      # Aplicar el resto de las personalizaciones.
      # Se excluyen las claves que ya han sido manejadas por pbGenerateEgg o por nosotros.
      # Apply the rest of the customizations.
      # Keys that have already been handled by pbGenerateEgg or by us are excluded.
      custom_config = final_config.reject do |k, _|
        [:species, :obtain_text, :steps_to_hatch, :variants].include?(k)
      end
      PokemonFactory.apply_attributes(egg, custom_config)

      pbMessage(_INTL("¡{1} obtuvo un huevo!", $player.name) + "\\me[Pkmn get]\\wtnp[80]")
      return egg
    end
  end


  #==============================================================================
  # ** Pokémon Factory **
  #------------------------------------------------------------------------------
  # Proporciona una fábrica para la creación y personalización de Pokémon.
  #==============================================================================
  # Provides a factory for creating and customizing Pokémon.
  #==============================================================================

  module PokemonFactory
    # --- Mapa interno para traducir claves de estadísticas ---
    # --- Internal map to translate stat keys ---
    STAT_MAP = {
      :HP              => :HP,
      :ATTACK          => :ATTACK,
      :ATK             => :ATTACK,
      :DEFENSE         => :DEFENSE,
      :DEF             => :DEFENSE,
      :SPECIAL_ATTACK  => :SPECIAL_ATTACK,
      :SPATK           => :SPECIAL_ATTACK,
      :SPA             => :SPECIAL_ATTACK,
      :SPECIAL_DEFENSE => :SPECIAL_DEFENSE,
      :SPDEF           => :SPECIAL_DEFENSE,
      :SPD             => :SPECIAL_DEFENSE,
      :SPEED           => :SPEED,
      :SPE             => :SPEED
    }

      # --- Registro Global de Datos / Global Data Registry ---
      @data = {}

      def self.data
        @data
      end

      def self.register(key, hash)
        @data[key] = hash
      end

    # --- Presets de IVs y EVs ---
    # --- IV and EV Presets ---
    IV_PRESETS = {
      :PERFECT     => { hp: 31, attack: 31, defense: 31, spatk: 31, spdef: 31, speed: 31 },
      :SPECIAL     => { hp: 31, attack: 0, defense: 31, spatk: 31, spdef: 31, speed: 31 },
      :TRICK_ROOM  => { hp: 31, attack: 31, defense: 31, spatk: 31, spdef: 31, speed: 0 },
      :ZERO        => { hp: 0, attack: 0, defense: 0, spatk: 0, spdef: 0, speed: 0 }
    }

    EV_PRESETS = {
      :SWEEPER_PHYSICAL => { attack: 252, speed: 252, hp: 4 },
      :SWEEPER_SPECIAL  => { spatk: 252, speed: 252, hp: 4 },
      :TANK_PHYSICAL    => { hp: 252, defense: 252, spdef: 4 },
      :TANK_SPECIAL     => { hp: 252, spdef: 252, defense: 4 }
    }

    class << self

      # El método principal de la fábrica. / The main factory method.
      def create(config_hash)

        if config_hash[:variants]
          # Si se proporciona la clave :variants, se procesa primero.
          # If the :variants key is provided, it is processed first.
          variant_config = process_variants(config_hash[:variants])

          # Si se elige una variante válida, su hash de configuración se fusiona
          # con el hash original. Las claves de la variante tienen prioridad.
          # If a valid variant is chosen, its configuration hash is merged
          # with the original hash. The variant's keys have priority.
          if variant_config
            config_hash = config_hash.merge(variant_config)
          end
        end

        # --- Creación Base / Base Creation ---

        # Obtiene la especie del hash. Usa :RATTATA como un valor por defecto seguro para evitar errores si no se especifica una especie.
        # Fetches the species from the hash. Uses :RATTATA as a safe default to prevent errors if no species is specified.
        species = config_hash.fetch(:species, :RATTATA)
        # Obtiene el nivel del hash. Usa 5 como un nivel por defecto razonable.
        # Fetches the level from the hash. Uses 5 as a reasonable default level.
        level = config_hash.fetch(:level, 5)
        # Crea la instancia del objeto Pokémon con la especie y el nivel determinados.
        # Creates the Pokémon object instance with the determined species and level.
        pkmn = Pokemon.new(species, level)


        if config_hash[:reset_moves] == false
          pkmn.moves.clear
        end

        # --- Aplicación de Modificadores de Base (ANTES de calc_stats) ---
        # --- Applying Base Modifiers (BEFORE calc_stats) ---
        if config_hash[:base_stats]
          pkmn.zbox_stat_mods = config_hash[:base_stats].transform_keys do |k|
            STAT_MAP[k.to_s.upcase.to_sym] || k.to_s.upcase.to_sym
          end
        end

        if config_hash[:types]
          pkmn.zbox_type_mods = config_hash[:types].map { |type| GameData::Type.get(type).id }
        end

        apply_type_mods(pkmn, config_hash[:types]) if config_hash[:types]

        # --- Recálculo Inicial de Estadísticas ---
        # --- Initial Stat Recalculation ---
        pkmn.calc_stats

        # --- Procesamiento del Resto de Atributos ---
        # --- Processing Remaining Attributes ---
        config_hash.each do |key, value|
          case key
          # Se omiten las claves ya procesadas
          # Skip keys that have already been processed
          when :species, :level, :base_stats, :types
            next

          # Atributos Simples
          # Simple Attributes
          when :nickname then pkmn.name = value
          when :shiny then pkmn.shiny = value
          when :super_shiny then pkmn.super_shiny = value
          when :form then pkmn.form = value
          when :gender then value.to_s.downcase == "male" ? pkmn.makeMale : pkmn.makeFemale
          when :nature then pkmn.nature = value

          when :hidden_power then
            pkmn.zbox_hp_type_mod = value

          when :move_pool then
            process_move_pool(pkmn, value)

          when :ability then pkmn.ability = value
          when :ability_index then pkmn.ability_index = value
          when :item then pkmn.item = value
          when :poke_ball then pkmn.poke_ball = value
          when :happiness then pkmn.happiness = value
          when :exp then pkmn.exp = value
          when :personal_id then pkmn.personalID = value
          when :time_received then pkmn.timeReceived = value

          # Atributos de Huevo
          # Egg Attributes
          when :steps_to_hatch then pkmn.steps_to_hatch = value
          when :hatched_map then pkmn.hatched_map = value
          when :time_egg_hatched then pkmn.timeEggHatched = value

          # Atributos de Estado
          # Status Attributes
          when :hp then pkmn.hp = value
          when :status then pkmn.status = value
          when :status_count then pkmn.statusCount = value # Para el sueño / For sleep

          # Atributos Complejos
          # Complex Attributes
          when :moves then value.each { |move| pkmn.learn_move(move) }
          when :first_moves then value.each { |move| pkmn.add_first_move(move) }

          when :ivs
            # Se determina si el valor es un símbolo de preset o un hash.
            # Determine if the value is a preset symbol or a hash.
            iv_hash = value.is_a?(Symbol) ? IV_PRESETS[value.to_s.upcase.to_sym] : value
            if iv_hash
              iv_hash.each do |stat_key, stat_val|
                engine_key = STAT_MAP[stat_key.to_s.upcase.to_sym]
                pkmn.iv[engine_key] = stat_val if engine_key
              end
            end

          when :evs
            # Se determina si el valor es un símbolo de preset o un hash.
            # Determine if the value is a preset symbol or a hash.
            ev_hash = value.is_a?(Symbol) ? EV_PRESETS[value.to_s.upcase.to_sym] : value
            if ev_hash
              ev_hash.each do |stat_key, stat_val|
                engine_key = STAT_MAP[stat_key.to_s.upcase.to_sym]
                pkmn.ev[engine_key] = stat_val if engine_key
              end
            end

          when :ribbons then value.each { |ribbon| pkmn.giveRibbon(ribbon) }
          when :markings then pkmn.markings = value

          # Propiedades del Entrenador Original
          # Original Trainer Properties
          when :owner_name then pkmn.owner.name = value
          when :owner_gender then pkmn.owner.gender = value
          when :owner_language then pkmn.owner.language = value
          when :owner_foreign
            if value == true
              pkmn.owner.id = $player.make_foreign_ID
            elsif value.is_a?(Integer)
              pkmn.owner.id = value
            end

          # Propiedades de Obtención
          # Obtention Properties
          when :obtain_level then pkmn.obtain_level = value
          when :obtain_map then pkmn.obtain_map = value
          when :obtain_text then pkmn.obtain_text = value
          when :obtain_method then pkmn.obtain_method = value

          # Estadísticas de Concurso
          # Contest Stats
          when :contest_stats then value.each { |stat, val| pkmn.send("#{stat}=", val) }

          # Restricciones
          # Restrictions
          when :discardable
            # Se asegura de que el valor sea un array para evitar errores.
            # Ensures the value is an array to prevent errors.
            Array(value).each do |restriction|
              # Construye el nombre del método (ej. "cannot_release=") y lo llama con `true`.
              # Builds the method name (e.g., "cannot_release=") and calls it with `true`.
              method_name = "cannot_#{restriction}="
              if pkmn.respond_to?(method_name)
                pkmn.send(method_name, true)
              else
              end
            end

          # Pokémon Especiales
          # Special Pokémon
          when :pokerus then pkmn.givePokerus(value)
          when :shadow then pkmn.makeShadow if value
          when :fused then pkmn.fused = value
          when :cry then pkmn.zbox_cry_mod = value
          when :can_evolve then pkmn.zbox_can_evolve = value
          when :add_stats
            pkmn.zbox_stat_additions = value.transform_keys do |k|
              STAT_MAP[k.to_s.upcase.to_sym] || k.to_s.upcase.to_sym
            end
          when :hidden_power then pkmn.zbox_hp_type_mod = value
          when :move_pool then process_move_pool(pkmn, value)
          when :sprite_override then pkmn.zbox_sprite_override = value
          when :hue_change then pkmn.zbox_hue_value = value
          when :palette_swap then pkmn.zbox_palette_swap = value
          when :type_chart_mods then pkmn.zbox_type_chart_mods = value
          when :type_chart_adds then pkmn.zbox_type_chart_adds = value
          when :custom_moves
            pkmn.zbox_move_mods ||= {}
            value.each do |move_mod|
              move_id = move_mod[:move]
              pkmn.learn_move(move_id)
              pkmn.zbox_move_mods[move_id] = move_mod.reject { |k, _| k == :move }
              if move_mod[:total_pp]
                new_move = pkmn.moves.find { |m| m.id == move_id }
                if new_move
                  base_pp = move_mod[:total_pp]
                  total_pp_custom = base_pp + (base_pp * new_move.ppup / 5)
                  new_move.pp = total_pp_custom
                end
              end
            end
          end
        end

        # --- Recálculo Final ---
        # --- Final Recalculation ---
        pkmn.calc_stats

        return pkmn
      end

      # Método para aplicar atributos a un Pokémon ya existente. / Method for applying attributes to an existing Pokémon.
      def apply_attributes(pkmn, config_hash)

        if config_hash[:base_stats]
          mods = config_hash[:base_stats].transform_keys { |k| STAT_MAP[k.to_s.upcase.to_sym] || k.to_s.upcase.to_sym }
          pkmn.define_singleton_method(:baseStats) do
            original_stats = super()
            next original_stats.merge(mods)
          end
        end

        apply_type_mods(pkmn, config_hash[:types]) if config_hash[:types]

        config_hash.each do |key, value|
          case key

          when :species, :level, :base_stats, :types
            next


          when :nickname then pkmn.name = value
          when :shiny then pkmn.shiny = value
          when :super_shiny then pkmn.super_shiny = value
          when :form then pkmn.form = value
          when :gender then value.to_s.downcase == "male" ? pkmn.makeMale : pkmn.makeFemale
          when :nature then pkmn.nature = value
          when :ability then pkmn.ability = value
          when :ability_index then pkmn.ability_index = value
          when :item then pkmn.item = value
          when :poke_ball then pkmn.poke_ball = value
          when :happiness then pkmn.happiness = value
          when :exp then pkmn.exp = value
          when :steps_to_hatch then pkmn.steps_to_hatch = value
          when :hatched_map then pkmn.hatched_map = value
          when :time_egg_hatched then pkmn.timeEggHatched = value
          when :personal_id then pkmn.personalID = value
          when :time_received then pkmn.timeReceived = value

          when :hp then pkmn.hp = value
          when :status then pkmn.status = value
          when :status_count then pkmn.statusCount = value

          when :moves then value.each { |move| pkmn.learn_move(move) }
          when :first_moves then value.each { |move| pkmn.add_first_move(move) }
          when :ivs
            iv_hash = value.is_a?(Symbol) ? IV_PRESETS[value.to_s.upcase.to_sym] : value
            if iv_hash
              iv_hash.each do |stat_key, stat_val|
                engine_key = STAT_MAP[stat_key.to_s.upcase.to_sym]
                pkmn.iv[engine_key] = stat_val if engine_key
              end
            end
          when :evs
            ev_hash = value.is_a?(Symbol) ? EV_PRESETS[value.to_s.upcase.to_sym] : value
            if ev_hash
              ev_hash.each do |stat_key, stat_val|
                engine_key = STAT_MAP[stat_key.to_s.upcase.to_sym]
                pkmn.ev[engine_key] = stat_val if engine_key
              end
            end
          when :ribbons then value.each { |ribbon| pkmn.giveRibbon(ribbon) }
          when :markings then pkmn.markings = value


          when :owner_name then pkmn.owner.name = value
          when :owner_gender then pkmn.owner.gender = value
          when :owner_language then pkmn.owner.language = value
          when :owner_foreign
            if value == true
              pkmn.owner.id = $player.make_foreign_ID
            elsif value.is_a?(Integer)
              pkmn.owner.id = value
            end

          when :obtain_level then pkmn.obtain_level = value
          when :obtain_map then pkmn.obtain_map = value
          when :obtain_text then pkmn.obtain_text = value
          when :obtain_method then pkmn.obtain_method = value

          when :contest_stats
            value.each { |stat, val| pkmn.send("#{stat}=", val) }

          when :discardable
            Array(value).each do |restriction|
              method_name = "cannot_#{restriction}="
              pkmn.send(method_name, true) if pkmn.respond_to?(method_name)
            end

          when :pokerus then pkmn.givePokerus(value)
          when :shadow then pkmn.makeShadow if value
          when :fused then pkmn.fused = value
          when :cry then pkmn.zbox_cry_mod = value
          when :can_evolve then pkmn.zbox_can_evolve = value
          when :add_stats
            pkmn.zbox_stat_additions = value.transform_keys do |k|
              STAT_MAP[k.to_s.upcase.to_sym] || k.to_s.upcase.to_sym
            end
          when :hidden_power then pkmn.zbox_hp_type_mod = value
          when :move_pool then process_move_pool(pkmn, value)
          when :sprite_override then pkmn.zbox_sprite_override = value
          when :hue_change then pkmn.zbox_hue_value = value
          when :palette_swap then pkmn.zbox_palette_swap = value
          when :type_chart_mods
            pkmn.zbox_type_chart_mods ||= {}
            pkmn.zbox_type_chart_mods.merge!(value)
          when :type_chart_adds
            pkmn.zbox_type_chart_adds ||= {}
            pkmn.zbox_type_chart_adds.merge!(value)
          when :custom_moves
            pkmn.zbox_move_mods ||= {}
            value.each do |move_mod|
              move_id = move_mod[:move]
              pkmn.learn_move(move_id)
              pkmn.zbox_move_mods[move_id] = move_mod.reject { |k, _| k == :move }
              if move_mod[:total_pp]
                new_move = pkmn.moves.find { |m| m.id == move_id }
                if new_move
                  base_pp = move_mod[:total_pp]
                  total_pp_custom = base_pp + (base_pp * new_move.ppup / 5)
                  new_move.pp = total_pp_custom
                end
              end
            end
          end
        end


        pkmn.calc_stats

        return pkmn
      end

      private

      # --- Método para procesar variantes ---
      # --- Method to process variants ---
      def process_variants(variants_array)
        # Filtrar las variantes.
        # Filter the variants.
        valid_variants = variants_array.select do |variant|
          # Si no hay condición, la variante siempre es válida.
          # If there is no condition, the variant is always valid.
          next true unless variant[:condition]
          # Si hay una condición, se ejecuta. La variante es válida solo si la condición devuelve true.
          # If there is a condition, it is executed. The variant is valid only if the condition returns true.
          next variant[:condition].call
        end

        return nil if valid_variants.empty?

        # Realizar el sorteo ponderado con la lógica nativa.
        # Perform the weighted draw with native logic.
        total_weight = valid_variants.sum { |variant| variant[:weight] || 0 }
        return nil if total_weight <= 0

        roll = rand(total_weight)

        chosen_variant = nil
        valid_variants.each do |variant|
          roll -= variant[:weight]
          if roll < 0
            chosen_variant = variant
            break
          end
        end

        # Si por algún error no se eligió ninguna, se elige la última válida como salvaguarda.
        # If for some reason none was chosen, the last valid one is chosen as a safeguard.
        chosen_variant ||= valid_variants.last

        # Devolver el hash de configuración de la variante elegida.
        # Return the configuration hash of the chosen variant.
        return chosen_variant[:config]
      end

      # --- Método para procesar el Pool de movimientos ---
      # --- Method to process the Move Pool ---
      def process_move_pool(pkmn, pool_config)
        return unless pool_config.is_a?(Hash) && pool_config[:moves].is_a?(Array)

        learn_count = pool_config[:learn_count] || 1
        num_to_learn = learn_count.is_a?(Range) ? rand(learn_count) : learn_count

        return if num_to_learn <= 0

        available_moves = pool_config[:moves].clone
        chosen_moves = []

        num_to_learn.times do
          break if available_moves.empty?

          # Se calcula el peso total de los movimientos restantes en CADA iteración.
          # The total weight of the remaining moves is calculated in EACH iteration.
          total_weight = available_moves.sum { |move_data| move_data[1] }
          break if total_weight <= 0

          # Se genera un número aleatorio dentro del rango del peso actual.
          # A random number is generated within the range of the current weight.
          roll = rand(total_weight)

          # Se itera para encontrar el movimiento elegido.
          # Iterate to find the chosen move.
          available_moves.each_with_index do |move_data, i|
            move_id, weight = move_data
            roll -= weight

            if roll < 0
              chosen_moves << move_id
              available_moves.delete_at(i)
              break
            end
          end
        end

        chosen_moves.each { |move| pkmn.learn_move(move) }
      end

      # --- Método para cambiar los tipos ---
      # --- Method to change types ---
      def apply_type_mods(pkmn, types_array)
        pkmn.zbox_type_mods = types_array.map { |type| GameData::Type.get(type).id }
      end
    end
  end
end
