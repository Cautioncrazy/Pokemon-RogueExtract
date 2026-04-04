#===============================================================================
# Global Relic System - Battle Hooks
#===============================================================================

class Battle::Move
  alias relic_hooks_pbCalcDamageMultipliers pbCalcDamageMultipliers unless method_defined?(:relic_hooks_pbCalcDamageMultipliers)
  alias relic_hooks_pbCalcAccuracyModifiers pbCalcAccuracyModifiers unless method_defined?(:relic_hooks_pbCalcAccuracyModifiers)

  def pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
    # Call original
    relic_hooks_pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)

    # RELIC_MUSCLE: Boosts physical Attack of all party members by 5% per stack.
    if user.pbOwnedByPlayer? && physicalMove?
      qty = $bag.quantity(:RELIC_MUSCLE)
      if qty > 0
        multipliers[:attack_multiplier] *= (1.0 + (0.05 * qty))
      end
    end
  end

  def pbCalcAccuracyModifiers(user, target, modifiers)
    # Call original
    relic_hooks_pbCalcAccuracyModifiers(user, target, modifiers)

    # RELIC_LENS: Increases Accuracy of all moves by 5% per stack.
    if user.pbOwnedByPlayer?
      qty = $bag.quantity(:RELIC_LENS)
      if qty > 0
        modifiers[:accuracy_multiplier] *= (1.0 + (0.05 * qty))
      end
    end
  end
end

class Battle
  alias relic_hooks_pbStartWeather pbStartWeather unless method_defined?(:relic_hooks_pbStartWeather)
  alias relic_hooks_pbStartTerrain pbStartTerrain unless method_defined?(:relic_hooks_pbStartTerrain)

  def pbStartWeather(user, newWeather, fixedDuration = false, showAnim = true)
    # The original pbStartWeather receives the user, and if user is player-owned we can increase duration
    # We must intercept it before it sets @field.weatherDuration, or modify it after.
    # The original method calculates duration first, then sets @field.weatherDuration = duration.
    # Since we can't easily modify the middle of the method, we will let it run and then add the relic extension.

    # Check if duration is limited (i.e. not -1) before adding extension
    # We need to know if it was limited to begin with.
    is_limited = fixedDuration || (user && user.itemActive?)

    relic_hooks_pbStartWeather(user, newWeather, fixedDuration, showAnim)

    if is_limited && @field.weatherDuration > 0 && user && user.pbOwnedByPlayer?
      qty = $bag.quantity(:RELIC_EXTENDER)
      if qty > 0
        @field.weatherDuration += qty
      end
    end
  end

  def pbStartTerrain(user, newTerrain, fixedDuration = true)
    is_limited = fixedDuration || (user && user.itemActive?)

    relic_hooks_pbStartTerrain(user, newTerrain, fixedDuration)

    if is_limited && @field.terrainDuration > 0 && user && user.pbOwnedByPlayer?
      qty = $bag.quantity(:RELIC_EXTENDER)
      if qty > 0
        @field.terrainDuration += qty
      end
    end
  end
end
