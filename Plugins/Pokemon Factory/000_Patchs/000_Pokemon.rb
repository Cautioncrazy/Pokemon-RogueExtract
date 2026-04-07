#==============================================================================
# ** Parche para Estadisticas base, Tipos del Pokémon y Bloquear evolución **
# ** Patch for Base Stats, Pokémon Types and Evolution lock **
#==============================================================================

class Pokemon
  # Se crean atributos para almacenar las modificaciones de forma segura.
  # Attributes are created to store modifications safely.
  attr_accessor :zbox_stat_mods
  attr_accessor :zbox_stat_additions
  attr_accessor :zbox_type_mods
  attr_accessor :zbox_type_chart_mods
  attr_accessor :zbox_type_chart_adds
  attr_accessor :zbox_hp_type_mod
  attr_accessor :zbox_cry_mod
  attr_accessor :zbox_can_evolve
  attr_accessor :zbox_move_mods
  attr_accessor :zbox_status_effect_id
  attr_accessor :zbox_sprite_override
  attr_accessor :zbox_hue_value
  attr_accessor :zbox_palette_swap

  
  # --- Parche para Estadísticas Base ---
  # --- Patch for Base Stats ---
  alias_method :zbox_original_baseStats, :baseStats
  def baseStats
    # 1. Se obtienen las estadísticas originales de la especie actual.
    stats = zbox_original_baseStats
    
    # 2. Se aplican los modificadores aditivos (persistentes).
    if @zbox_stat_additions
      @zbox_stat_additions.each do |stat, value|
        stats[stat] += value if stats[stat]
      end
    end
    
    # 3. Se aplican los overrides (no persistentes, específicos de la especie).
    if @zbox_stat_mods
      stats = stats.merge(@zbox_stat_mods)
    end
    
    return stats
  end
  
  # --- Parche para Tipos ---
  # --- Patch for Types ---
  alias_method :zbox_original_types, :types
  def types
    # Si no hay modificaciones, se llama al método original.
    # If there are no modifications, call the original method.
    return zbox_original_types unless @zbox_type_mods
    # Si hay modificaciones, se devuelven los tipos modificados.
    # If there are modifications, return the modified types.
    return @zbox_type_mods
  end

  # --- Parche para bloquear las Evoluciones ---
  # --- Patch to block Evolutions ---
  alias_method :zbox_original_check_evolution_internal, :check_evolution_internal
  def check_evolution_internal(*args, &block)
    # Si se detecta la bandera de bloqueo, se devuelve nil (sin evolución).
    # If the block flag is detected, return nil (no evolution).
    if @zbox_can_evolve == false
      return nil
    end
    
    # Se pasa el bloque de código al método original usando `&block`.
    # The code block is passed to the original method using `&block`.
    return zbox_original_check_evolution_internal(*args, &block)
  end

  # --- Parche para SuperShinys ---
  # --- Patch to SuperShinys ---
  alias_method :zbox_factory_set_super_shiny, :super_shiny=
  def super_shiny=(value)
    zbox_factory_set_super_shiny(value)

    if value == true
      @zbox_hue_value = nil
      self.zbox_get_super_shiny_hue
    end
  end
end

#==============================================================================
# ** Parche para Poder Oculto **
# ** Patch for Hidden Power **
#==============================================================================

# Se guarda una referencia a la función global original.
# A reference to the original global function is saved.
alias zbox_original_pbHiddenPower pbHiddenPower

# --- Se define una nueva función global con el mismo nombre ---
# --- A new global function with the same name is defined ---
def pbHiddenPower(pkmn)
  # Se comprueba si el Pokémon pasado como argumento tiene la
  # variable de modificación.
  # Check if the Pokémon passed as an argument has the
  # modification variable.
  if pkmn.respond_to?(:zbox_hp_type_mod) && pkmn.zbox_hp_type_mod
    # Si la tiene, se devuelve el tipo forzado y se ignora el resto.
    # If it has it, the forced type is returned and the rest is ignored.
    return [GameData::Type.get(pkmn.zbox_hp_type_mod).id, 60]
  end
  
  # Si no hay modificación, se llama a la función original que guardamos.
  # If there is no modification, the original function we saved is called.
  return zbox_original_pbHiddenPower(pkmn)
end

#==============================================================================
# ** Parche para Grito Personalizado **
# ** Patch for Custom Cry **
#==============================================================================
module GameData
  class Species
    class << self
      # Se guarda una referencia al método de clase original.
      # A reference to the original class method is saved.
      alias_method :zbox_original_cry_filename_from_pokemon, :cry_filename_from_pokemon

      # Se define un nuevo método de clase con el mismo nombre.
      # A new class method with the same name is defined.
      def cry_filename_from_pokemon(pkmn, suffix = "")
        # Se comprueba si el Pokémon tiene nuestra variable de modificación.
        # Check if the Pokémon has our modification variable.
        if pkmn.respond_to?(:zbox_cry_mod) && pkmn.zbox_cry_mod
          # Si la tiene, se devuelve el nombre del archivo SIN la ruta "Audio/SE/".
          # Este es el formato que el resto del motor espera.
          # If it has it, the filename is returned WITHOUT the "Audio/SE/" path.
          # This is the format the rest of the engine expects.
          cry_filename = pkmn.zbox_cry_mod.sub("Audio/SE/", "")
          
          # Se comprueba si el archivo personalizado existe. Si no, se pasa al original.
          # Check if the custom file exists. If not, it passes to the original.
          return cry_filename if pbResolveAudioSE(cry_filename)
        end
        
        # Si no hay modificación, se llama al método original.
        # If there is no modification, the original method is called.
        return zbox_original_cry_filename_from_pokemon(pkmn, suffix)
      end
    end
  end
end