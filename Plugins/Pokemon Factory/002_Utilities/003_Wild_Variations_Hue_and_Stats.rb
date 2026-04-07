#===================================================================================
# Añade una ligera variación de HUE y STATS a todos los Pokémon salvajes generados.
# Adds a slight variation to the HUE and STATS of all spawned wild Pokémon.
#===================================================================================
EventHandlers.add(:on_wild_pokemon_created, :zbox_wild_pokemon_mods,
  proc { |pkmn|

    # --- Aplicar Variación de HUE ---
    # --- Apply Hue Variation ---
    if Settings::VARIATION_COLOR_WILDPOKEMON && Settings::VARIATION_COLOR > 0
      if !pkmn.super_shiny? && (!pkmn.respond_to?(:zbox_hue_value) || !pkmn.zbox_hue_value)
        range = (Settings::VARIATION_COLOR * 2) + 1
        random_hue = rand(range) - Settings::VARIATION_COLOR
    
        # Se asigna el valor al Pokémon.
        # The value is assigned to the Pokémon.
        pkmn.zbox_hue_value = random_hue
      end
    end

    # --- Aplicar Variación de Estadísticas ---
    # --- Apply Variance Statistics ---
    if Settings::VARIATION_STATS_WILDPOKEMON && Settings::VARIATION_STATS > 0
      # Se inicializa el hash de modificaciones aditivas.
      # The additive modification hash is initialized.
      stat_additions = {}
      range = (Settings::VARIATION_STATS * 2) + 1

      # Se itera sobre cada estadística de batalla.
      # Iterates over each battle statistic.
      GameData::Stat.each_main do |s|
        random_mod = rand(range) - Settings::VARIATION_STATS
        
        # Se añade la modificación al hash.
        # The modification is added to the hash.
        stat_additions[s.id] = random_mod
      end
      
      # Se asigna el hash completo al Pokémon.
      # The complete hash is assigned to the Pokémon.
      pkmn.zbox_stat_additions = stat_additions
    end
  }
)