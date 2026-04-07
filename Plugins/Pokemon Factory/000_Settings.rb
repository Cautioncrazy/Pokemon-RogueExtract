#=================================================================================
# Pokemon Factory
#
# Autor / Author: Zik
#=================================================================================
# Este script permite la creación de Pokémon totalmente personalizables.
# Aplicando las modificaciones necesarias a Essentials para que pueda alterar
# propiedades "inmutables".
#=================================================================================
# This script allows the creation of fully customizable Pokémon. It applies the
# necessary modifications to Essentials so that it can alter "immutable"
# properties.
#=================================================================================

module Settings
  # --- Añade una ligera variación de HUE y STATS a todos los Pokémon salvajes generados. ---
  # --- Adds a slight variation to the HUE and STATS of all spawned wild Pokémon. ---
  # El rango de variación de HUE será de (-VARIATION_COLOR) a (+VARIATION_COLOR).
  # The HUE variation range will be from (-VARIATION_COLOR) to (+VARIATION_COLOR).
  VARIATION_COLOR_WILDPOKEMON = true
  VARIATION_COLOR = 30

  # El rango de variación para cada estadística base será de (-VARIATION_STATS) a (+VARIATION_STATS).
  # The variation range for each base stat will be from (-VARIATION_STATS) to (+VARIATION_STATS).
  VARIATION_STATS_WILDPOKEMON = true
  VARIATION_STATS = 15


  # --- Añade una ligera variación de HUE y STATS a los Pokémon de entrenadores. ---
  # --- Adds a slight variation of HUE and STATS to trainer Pokémon. ---
  # El rango de variación de HUE será de (-VARIATION_COLOR_TRAINER) a (+VARIATION_COLOR_TRAINER).
  # The HUE variation range will be from (-VARIATION_COLOR_TRAINER) to (+VARIATION_COLOR_TRAINER).
  VARIATION_COLOR_TRAINERPOKEMON = true
  VARIATION_COLOR_TRAINER = 30

  # El rango de variación para cada estadística base será de (-VARIATION_STATS_TRAINER) a (+VARIATION_STATS_TRAINER).
  # The variation range for each base stat will be from (-VARIATION_STATS_TRAINER) to (+VARIATION_STATS_TRAINER).
  VARIATION_STATS_TRAINERPOKEMON = true
  VARIATION_STATS_TRAINER = 15
end