#==============================================================================
# ** Parche para Tabla de Tipos Personalizada **
# ** Patch for Custom Type Chart **
#==============================================================================
class Battle::Move
  alias_method :zbox_pbCalcTypeMod, :pbCalcTypeMod

  def pbCalcTypeMod(moveType, user, target)
    # --- Lógica de Reemplazo Total (type_chart_mods) ---
    # --- Total Replacement Logic (type_chart_mods) ---
    if target.pokemon&.respond_to?(:zbox_type_chart_mods)
      type_mods = target.pokemon.zbox_type_chart_mods
      if type_mods && !type_mods.empty?
        mod_key = moveType.to_s.upcase.to_sym
        if type_mods.key?(mod_key)
          custom_value = type_mods[mod_key]
          multiplier = custom_value.is_a?(Numeric) ? custom_value : (custom_value / Effectiveness::NORMAL_EFFECTIVE.to_f)
          multiplier *= 2 if target.effects[PBEffects::TarShot] && moveType == :FIRE

          if multiplier > 1
            target.damageState.typeMod = Effectiveness::SUPER_EFFECTIVE
          elsif multiplier > 0 && multiplier < 1
            target.damageState.typeMod = Effectiveness::NOT_VERY_EFFECTIVE
          elsif multiplier == 0
            target.damageState.typeMod = Effectiveness::INEFFECTIVE
          else
            target.damageState.typeMod = Effectiveness::NORMAL_EFFECTIVE
          end
          return multiplier
        else
          target.damageState.typeMod = Effectiveness::NORMAL_EFFECTIVE
          return Effectiveness::NORMAL_EFFECTIVE_MULTIPLIER
        end
      end
    end

    # --- Lógica Aditiva (type_chart_adds) ---
    # --- Additive Logic (type_chart_adds) ---
    base_multiplier = zbox_pbCalcTypeMod(moveType, user, target)

    if target.pokemon&.respond_to?(:zbox_type_chart_adds)
      type_adds = target.pokemon.zbox_type_chart_adds
      if type_adds && !type_adds.empty?
        mod_key = moveType.to_s.upcase.to_sym

        if type_adds.key?(mod_key)
          custom_value = type_adds[mod_key]
          add_multiplier = custom_value.is_a?(Numeric) ? custom_value : (custom_value / Effectiveness::NORMAL_EFFECTIVE.to_f)
          return base_multiplier * add_multiplier
        end
      end
    end

    return base_multiplier
  end
end