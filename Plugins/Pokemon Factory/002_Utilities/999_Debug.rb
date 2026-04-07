if $DEBUG
  #==============================================================================
  # Muestra en la consola las modificaciones de HUE y Stats de los Pokémon
  # salvajes al inicio de la batalla.
  # Displays on the console the HUE and Stats modifications of wild Pokémon 
  # at the start of the battle.
  #==============================================================================
  class Battle
    alias_method :zbox_debug_on_battlers_entering, :pbOnAllBattlersEnteringBattle  
    def pbOnAllBattlersEnteringBattle
      zbox_debug_on_battlers_entering
    
      @battlers.each do |b|
        next if !b || !b.wild?
        
        pkmn = b.pokemon
        
        debug_message = "--- Wild Pokémon Mods for #{pkmn.name} (Index: #{b.index}) ---"
        
        if pkmn.respond_to?(:zbox_hue_value) && pkmn.zbox_hue_value
          debug_message += "\nHue Change: #{pkmn.zbox_hue_value}"
        end
      
        if pkmn.respond_to?(:zbox_stat_additions) && pkmn.zbox_stat_additions
          stats_str = pkmn.zbox_stat_additions.map { |stat, val|
            formatted_val = val >= 0 ? "+#{val}" : val
            "#{stat}: #{formatted_val}"
          }.join(", ")
          debug_message += "\nStat Additions: { #{stats_str} }"
        end 
        puts debug_message
        puts "----------------------------------------------------"
      end
    end
  end

  #==============================================================================
  # Añade una opción para ejecutar los eventos de la Pokémon Factory.
  # Add an option to run Pokémon Factory events.
  #==============================================================================
  module ZBox
    # Este hash almacena los métodos de entrega que se mostrarán en el menú de depuración.
    # This hash stores the delivery methods that will be displayed in the debug menu.
    FACTORY_EVENT_REGISTRY = {}

    # Método de ayuda para registrar un nuevo evento.
    # Help method for registering a new event.
    def self.register_factory_event(display_name, method_symbol, description)
      FACTORY_EVENT_REGISTRY[display_name] = {
        method: method_symbol,
        desc: description
      }
    end
  end

  ZBox.register_factory_event(
    "Abyssal Guardian (Corviknight)",
    :give_abyssal_guardian,
    "Ejemplo completo que muestra la mayoría de las configuraciones de la Factory."
  )
  ZBox.register_factory_event(
    "Eevee Hope",
    :give_eevee,
    "Ejemplo básico de un Eevee shiny con buenos IVs."
  )
  ZBox.register_factory_event(
    "Alpha Growlithe (Cannot Evolve)",
    :give_alpha_growlithe,
    "Ejemplo de un Pokémon con stats base modificadas usando las de otro pokémon más un agregado y usando can_evolve: para bloquear su evolución."
  )
  ZBox.register_factory_event(
    "Porygon Glitch (Base Stats)",
    :give_glitched_porygon,
    "Demuestra el uso de base_stats: para crear un Pokémon que sin importar que evolucione o cambie de forma, sus stats base no cambiarán."
  )
  ZBox.register_factory_event(
    "Lineage Eevee (Add Stats)",
    :give_lineage_eevee,
    "Demuestra el uso de add_stats: para crear un Pokémon cuyas stats base podrá aumentar+ o disminuir-. Esta variabilidad permanece aunque evolucione o cambie de forma."
  )
  ZBox.register_factory_event(
    "Special Eevee Egg",
    :give_special_eevee_egg,
    "Ejemplo de la EggFactory para crear un huevo con propiedades predefinidas."
  )
  ZBox.register_factory_event(
    "Mystery Pichu (Move Pool)",
    :give_mystery_pichu,
    "Demuestra el uso de move_pool:. Este pichu puede venir con los movimientos :SURF o :FLY, pero tiene una pequeña chance de venir con ambos."
  )
  ZBox.register_factory_event(
    "Eevee (Sprite Override and Hue Change)",
    :give_eevee_override,
    "Demuestra el uso de sprite_override: que cambiará los sprites que se mostrarán(front, back, etc.). Así como el uso de hue_change: que cambiará el tono de paleta del pokémon."
  )
  ZBox.register_factory_event(
    "Bulbasaur Dry (Palette Swap)",
    :give_bulbasaur_dry,
    "Demuestra el uso de palette_swap: para cambiar selectivamente la paleta de colores de un Pokémon usando una imagen como mapa de color."
  )
  ZBox.register_factory_event(
    "Figth Golem (Type Chart Mods)",
    :figth_golem,
    "Demuestra el uso de type_chart_mods: para cambiar la efectividad y resistencia que tendrá el pokémon sin importar sus propios tipos. Debil x6 a AGUA Y PLANTA. Resiste x0.1 a NORMAL, VENENO Y FUEGO."
  )
  ZBox.register_factory_event(
    "Figth Fat Snorlax (Type Chart Adds)",
    :figth_fat_snorlax,
    "Demuestra el uso de type_chart_ads: para agregar efectividades y resistencias a las ya existentes en el pokémon. Se agrega resistencias x0.5 a FUEGO Y HIELO."
  )
  ZBox.register_factory_event(
    "Regional Bird (Variants)",
    :give_regional_bird,
    "Demuestra el uso de variants: para entregar distintos pokémon incluyendo tambien condicionales."
  )
  ZBox.register_factory_event(
    "Multibuild Arcanine (Variants)",
    :give_multibuild_arcanine,
    "Demuestra el uso de variants: para entregar un mismo Pokémon con distintas variantes."
  )
  ZBox.register_factory_event(
    "Fossil Egg (Variants)",
    :give_fossil_egg,
    "Demuestra el uso de variants: para entregar un huevo."
  )
  ZBox.register_factory_event(
    "Anomalous Tyranitar (Custom Moves)",
    :give_anomalous_tyranitar,
    "Demuestra el uso de custom_moves: para crear movimientos personalizados."
  )
  ZBox.register_factory_event(
    "Pikachu of Ash (Custom Moves)",
    :give_pikachu_of_ash,
    "Demuestra el uso de custom_moves: junto a moves:."
  )
  ZBox.register_factory_event(
    "Berserker Dragonite (Status Effect)",
    :give_berserker_dragonite,
    "Demuestra el uso de stat_changes: y apply_status_to_user: en status_effect: para crear un movimiento(:DRAGONDANCE) que afecta al usuario."
  )
  ZBox.register_factory_event(
    "Spooky Gengar (Status Effect and Target)",
    :give_spooky_gengar,
    "Demuestra el uso de stat_changes_target: y apply_status_to_target: en status_effect: para crear un movimiento(:SCARYFACE) que afecta a un objetivo. Ademas de usar target: para definir el alcance del movimiento."
  )
  ZBox.register_factory_event(
    "Drought Torkoal (Status Effect)",
    :give_drought_torkoal,
    "Demuestra el uso de change_weather: en status_effect: para crear un movimiento(:SUNNYDAY) que puede alterar el clima."
  )
  ZBox.register_factory_event(
    "Psy Gardevoir (Status Effect)",
    :give_psy_gardevoir,
    "Demuestra el uso de change_terrain: en status_effect: para crear un movimiento(:CALMMIND) que puede alterar el terreno."
  )
  ZBox.register_factory_event(
    "Trapper Ariados (Status Effect)",
    :give_trapper_ariados,
    "Demuestra el uso de add_hazards_to_target_side: en status_effect: para crear un movimiento(:TOXICSPIKES) que puede poner trampas."
  )
  ZBox.register_factory_event(
    "Support Alcremi (Status Effect)",
    :give_support_alcremie,
    "Demuestra el uso de add_side_effect_to_user: en status_effect: para crear un movimiento(:DECORATE) de soporte."
  )
  ZBox.register_factory_event(
    "Sacrifice Gardevoir (Status Effect)",
    :give_sacrifice_gardevoir,
    "Demuestra el uso de recoil_user: y heal_user: en status_effect: para crear un movimiento(:CELEBRATE) que cura al usuario o genera daño de retroceso."
  )
  ZBox.register_factory_event(
    "Healer Chansey (Status Effect)",
    :give_healer_chansey,
    "Demuestra el uso de heal_target: en status_effect: para crear un movimiento(:GROWL) que cura a un objetivo."
  )
  ZBox.register_factory_event(
    "Figth Dragon Charmander (Status Effect)",
    :figth_dragon_charmander,
    "Demuestra el uso de fixed_damage_target: en status_effect: para crear un movimiento(:EMBER) que hace un daño fijo."
  )
  ZBox.register_factory_event(
    "Sabouter Sableye (Status Effect)",
    :give_saboteur_sableye,
    "Demuestra el uso de suppress_target_ability: en status_effect: para crear un movimiento(:CONFUSERAY) que suprime la habilidad. Puedes editar el metodo para probar change_target_ability: para cambiar la habilidad o disable_target_last_move: para desactivar el último movimiento por 'x' turnos."
  )

  MenuHandlers.add(:debug_menu, :pokemon_factory_events, {
    "name"        => _INTL("Eventos de Pokémon Factory..."),
    "parent"      => :pokemon_menu,
    "description" => _INTL("Ejecuta los métodos de entrega de Pokémon definidos en la Pokémon Factory."),
    "effect"      => proc {
      # Se comprueba si hay eventos registrados.
      # Check if there are any registered events.
      if !defined?(ZBox::FACTORY_EVENT_REGISTRY) || ZBox::FACTORY_EVENT_REGISTRY.empty?
        pbMessage(_INTL("No hay eventos de la Pokémon Factory registrados."))
        next
      end
      
      loop do
        commands = ZBox::FACTORY_EVENT_REGISTRY.keys      
        cmd = pbMessage(_INTL("Elige un evento de la Factory para ejecutar."), commands, -1)
        break if cmd < 0

        selected_event_name = commands[cmd]
        event_data = ZBox::FACTORY_EVENT_REGISTRY[selected_event_name]

        message = _INTL("Descripción: {1}", event_data[:desc])
        message += "\n" + _INTL("¿Ejecutar este evento?")
        
        if pbConfirmMessage(message)
          pbMessage(_INTL("Ejecutando {1}...", selected_event_name))
          ZBox.send(event_data[:method])
          pbMessage(_INTL("¡Evento completado!"))
        end
      end
    }
  })

=begin  
  ZBox.register_factory_event(
    "Abyssal Guardian (Corviknight)",
    :give_abyssal_guardian,
    "Complete example showcasing most of the Factory's configurations."
  )
  ZBox.register_factory_event(
    "Eevee Hope",
    :give_eevee,
    "Basic example of a shiny Eevee with good IVs."
  )
  ZBox.register_factory_event(
    "Alpha Growlithe (Cannot Evolve)",
    :give_alpha_growlithe,
    "Example of a Pokémon with modified base stats using another Pokémon's stats plus an addition, and using can_evolve: to block its evolution."
  )
  ZBox.register_factory_event(
    "Porygon Glitch (Base Stats)",
    :give_glitched_porygon,
    "Demonstrates the use of base_stats: to create a Pokémon whose base stats will not change regardless of evolution or form changes."
  )
  ZBox.register_factory_event(
    "Lineage Eevee (Add Stats)",
    :give_lineage_eevee,
    "Demonstrates the use of add_stats: to create a Pokémon whose base stats can be increased+ or decreased-. This variability remains even when it evolves or changes form."
  )
  ZBox.register_factory_event(
    "Special Eevee Egg",
    :give_special_eevee_egg,
    "Example of the EggFactory to create an egg with predefined properties."
  )
  ZBox.register_factory_event(
    "Mystery Pichu (Move Pool)",
    :give_mystery_pichu,
    "Demonstrates the use of move_pool:. This Pichu can come with the moves :SURF or :FLY, but has a small chance of coming with both."
  )
  ZBox.register_factory_event(
    "Eevee (Sprite Override and Hue Change)",
    :give_eevee_override,
    "Demonstrates the use of sprite_override: which will change the sprites displayed (front, back, etc.). As well as the use of hue_change: which will change the Pokémon's palette tone."
  )
  ZBox.register_factory_event(
    "Bulbasaur Dry (Palette Swap)",
    :give_bulbasaur_dry,
    "Demonstrates the use of palette_swap: to selectively change a Pokémon's color palette using an image as a color map."
  )
  ZBox.register_factory_event(
    "Figth Golem (Type Chart Mods)",
    :figth_golem,
    "Demonstrates the use of type_chart_mods: to change the effectiveness and resistance the Pokémon will have regardless of its own types. Weak x6 to WATER AND GRASS. Resists x0.1 to NORMAL, POISON AND FIRE."
  )
  ZBox.register_factory_event(
    "Figth Fat Snorlax (Type Chart Adds)",
    :figth_fat_snorlax,
    "Demonstrates the use of type_chart_adds: to add effectiveness and resistances to those already existing on the Pokémon. Adds x0.5 resistance to FIRE AND ICE."
  )
  ZBox.register_factory_event(
    "Regional Bird (Variants)",
    :give_regional_bird,
    "Demonstrates the use of variants: to deliver different Pokémon, also including conditionals."
  )
  ZBox.register_factory_event(
    "Multibuild Arcanine (Variants)",
    :give_multibuild_arcanine,
    "Demonstrates the use of variants: to deliver the same Pokémon with different variants."
  )
  ZBox.register_factory_event(
    "Fossil Egg (Variants)",
    :give_fossil_egg,
    "Demonstrates the use of variants: to deliver an egg."
  )
  ZBox.register_factory_event(
    "Anomalous Tyranitar (Custom Moves)",
    :give_anomalous_tyranitar,
    "Demonstrates the use of custom_moves: to create custom moves."
  )
  ZBox.register_factory_event(
    "Pikachu of Ash (Custom Moves)",
    :give_pikachu_of_ash,
    "Demonstrates the use of custom_moves: together with moves:."
  )
  ZBox.register_factory_event(
    "Berserker Dragonite (Status Effect)",
    :give_berserker_dragonite,
    "Demonstrates the use of stat_changes: and apply_status_to_user: in status_effect: to create a move(:DRAGONDANCE) that affects the user."
  )
  ZBox.register_factory_event(
    "Spooky Gengar (Status Effect and Target)",
    :give_spooky_gengar,
    "Demonstrates the use of stat_changes_target: and apply_status_to_target: in status_effect: to create a move(:SCARYFACE) that affects a target. Also uses target: to define the move's scope."
  )
  ZBox.register_factory_event(
    "Drought Torkoal (Status Effect)",
    :give_drought_torkoal,
    "Demonstrates the use of change_weather: in status_effect: to create a move(:SUNNYDAY) that can alter the weather."
  )
  ZBox.register_factory_event(
    "Psy Gardevoir (Status Effect)",
    :give_psy_gardevoir,
    "Demonstrates the use of change_terrain: in status_effect: to create a move(:CALMMIND) that can alter the terrain."
  )
  ZBox.register_factory_event(
    "Trapper Ariados (Status Effect)",
    :give_trapper_ariados,
    "Demonstrates the use of add_hazards_to_target_side: in status_effect: to create a move(:TOXICSPIKES) that can set traps."
  )
  ZBox.register_factory_event(
    "Support Alcremi (Status Effect)",
    :give_support_alcremie,
    "Demonstrates the use of add_side_effect_to_user: in status_effect: to create a support move(:DECORATE)."
  )
  ZBox.register_factory_event(
    "Sacrifice Gardevoir (Status Effect)",
    :give_sacrifice_gardevoir,
    "Demonstrates the use of recoil_user: and heal_user: in status_effect: to create a move(:CELEBRATE) that heals the user or deals recoil damage."
  )
  ZBox.register_factory_event(
    "Healer Chansey (Status Effect)",
    :give_healer_chansey,
    "Demonstrates the use of heal_target: in status_effect: to create a move(:GROWL) that heals a target."
  )
  ZBox.register_factory_event(
    "Figth Dragon Charmander (Status Effect)",
    :figth_dragon_charmander,
    "Demonstrates the use of fixed_damage_target: in status_effect: to create a move(:EMBER) that deals fixed damage."
  )
  ZBox.register_factory_event(
    "Sabouter Sableye (Status Effect)",
    :give_saboteur_sableye,
    "Demonstrates the use of suppress_target_ability: in status_effect: to create a move (:CONFUSERAY) that suppresses the ability. You can edit the method to test change_target_ability: to change the ability or disable_target_last_move: to disable the last move for 'x' turns."
  )

  MenuHandlers.add(:debug_menu, :pokemon_factory_events, {
    "name"        => _INTL("Pokémon Factory Events..."),
    "parent"      => :pokemon_menu,
    "description" => _INTL("Execute the Pokémon delivery methods defined in the Pokémon Factory."),
    "effect"      => proc {
      # Se comprueba si hay eventos registrados.
      # Check if there are any registered events.
      if !defined?(ZBox::FACTORY_EVENT_REGISTRY) || ZBox::FACTORY_EVENT_REGISTRY.empty?
        pbMessage(_INTL("There are no Pokémon Factory events registered."))
        next
      end
      
      loop do
        commands = ZBox::FACTORY_EVENT_REGISTRY.keys      
        cmd = pbMessage(_INTL("Choose a Factory event to run."), commands, -1)
        break if cmd < 0

        selected_event_name = commands[cmd]
        event_data = ZBox::FACTORY_EVENT_REGISTRY[selected_event_name]

        message = _INTL("Description: {1}", event_data[:desc])
        message += "\n" + _INTL("Execute this event?")
        
        if pbConfirmMessage(message)
          pbMessage(_INTL("Running {1}...", selected_event_name))
          ZBox.send(event_data[:method])
          pbMessage(_INTL("¡Event completed!"))
        end
      end
    }
  })
=end  
  
end
