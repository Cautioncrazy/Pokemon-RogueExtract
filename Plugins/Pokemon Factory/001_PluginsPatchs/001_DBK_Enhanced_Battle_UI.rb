
#=============================================================================
# Parche para [DBK] Enhanced Battle UI
# Patch for [DBK] Enhanced Battle UI
#=============================================================================

if PluginManager.installed?("[DBK] Enhanced Battle UI")
  class Battle::Scene 
    alias_method :zbox_updateMoveInfoWindow, :pbUpdateMoveInfoWindow
    def pbUpdateMoveInfoWindow(battler, specialAction, cw)
      @enhancedUIOverlay.clear
      return if @enhancedUIToggle != :move
      xpos = 0
      ypos = 94
      move = battler.moves[cw.index]
      if battler.dynamax? || specialAction == :dynamax && cw.mode == 2
        move = move.convert_dynamax_move(battler, @battle)
      end
      powBase   = accBase   = priBase   = effBase   = BASE_LIGHT
      powShadow = accShadow = priShadow = effShadow = SHADOW_LIGHT
      basePower = calcPower = power = move.pbBaseDamage(battler, battler.pbDirectOpposing(true))
      category = move.display_category(battler)
      type = move.pbCalcType(battler)
      terastal = battler.tera? || (specialAction == :tera && cw.teraType > 0)
      #---------------------------------------------------------------------------
      # Gets move type and category (for display purposes).
      case move.function_code
      when "CategoryDependsOnHigherDamageTera",
           "TerapagosCategoryDependsOnHigherDamage"
        if terastal
          case move.function_code
          when "CategoryDependsOnHigherDamageTera"
            type = battler.tera_type
            basePower = calcPower = power = 100
          when "TerapagosCategoryDependsOnHigherDamage"
            type = :STELLAR if battler.isSpecies?(:TERAPAGOS)
          end
          realAtk, realSpAtk = battler.getOffensiveStats
          category = (realAtk > realSpAtk) ? 0 : 1
        else
          type = move.type
          category = move.calcCategory
        end
      when "CategoryDependsOnHigherDamagePoisonTarget", 
           "CategoryDependsOnHigherDamageIgnoreTargetAbility"
        move.pbOnStartUse(battler, [battler.pbDirectOpposing])
        category = move.calcCategory
      end
      #---------------------------------------------------------------------------
      # Draws images.
      typenumber = GameData::Type.get(type).icon_position
      bgnumber = (Settings::USE_MOVE_TYPE_BACKGROUNDS) ? typenumber + 1 : 0
      imagePos = [
        [@path + "move_bg",      xpos,       ypos,     0, bgnumber * 164, 512, 164],
        ["Graphics/UI/types",    xpos + 282, ypos + 8, 0, typenumber * 28, 64, 28],
        ["Graphics/UI/category", xpos + 350, ypos + 8, 0, category * 28, 64, 28]
      ]
      pbDrawMoveFlagIcons(xpos, ypos, move, imagePos)
      pbDrawTypeEffectiveness(xpos, ypos, move, type, imagePos)
      pbDrawImagePositions(@enhancedUIOverlay, imagePos)
      #---------------------------------------------------------------------------
      # Move damage calculations (for display purposes).
      if move.damagingMove?
        if terastal
          if battler.typeTeraBoosted?(type, true)
            bonus = (battler.tera_type == :STELLAR) ? 1.2 : 1.5
            stab = (battler.types.include?(type)) ? 2 : bonus
          else
            stab = (battler.types.include?(type)) ? 1.5 : 1
          end
        else
          stab = (battler.pbHasType?(type)) ? 1.5 : 1
        end
        stab = 1 if defined?(move.pbFixedDamage(battler, battler.pbDirectOpposing))
        hidePower = false
        case move.function_code
        when "ThrowUserItemAtTarget"                     # Fling
          hidePower = true if !battler.item
        when "TypeAndPowerDependOnUserBerry"             # Natural Gift
          hidePower = true if !battler.item || !battler.item.is_berry?
        when "PursueSwitchingFoe",                       # Pursuit
             "RemoveTargetItem",                         # Knock Off
             "HitOncePerUserTeamMember",                 # Beat Up
             "DoublePowerIfTargetActed",                 # Payback
             "DoublePowerIfTargetNotActed",              # Bolt Beak, Fishious Rend
             "PowerHigherWithTargetHP",                  # Crush Grip, Wring Out
             "PowerHigherWithTargetHP100PowerRange",     # Hard Press
             "HitThreeTimesPowersUpWithEachHit",         # Triple Kick
             "PowerHigherWithTargetWeight",              # Low Kick, Grass Knot
             "PowerHigherWithUserFasterThanTarget",      # Electro Ball
             "PowerHigherWithTargetFasterThanUser",      # Gyro Ball
             "FixedDamageUserLevelRandom",               # Psywave
             "RandomlyDamageOrHealTarget",               # Present
             "RandomlyDealsDoubleDamage",                # Fickle Beam
             "RandomPowerDoublePowerIfTargetUnderground" # Magnitude
          hidePower = true if calcPower == 1
        end
        if !hidePower
          calcPower = move.pbBaseDamage(basePower, battler, battler.pbDirectOpposing)
          calcPower = move.pbModifyDamage(calcPower, battler, battler.pbDirectOpposing)
          calcPower = move.pbBaseDamageTera(calcPower, battler, type, true) if terastal
        end
        hidePower = true if calcPower == 1
        powerDiff = (move.function_code == "PowerHigherWithUserHP") ? calcPower - basePower : basePower - calcPower
        calcPower *= stab
        power = (calcPower >= powerDiff) ? calcPower : basePower * stab
      end
      #---------------------------------------------------------------------------
      # Final move attribute calculations.
      acc = move.display_accuracy(battler)
      pri = move.pbPriority(battler)
      case move.function_code
      when "ParalyzeFlinchTarget", "BurnFlinchTarget", "FreezeFlinchTarget"
        chance = 10
      when "LowerTargetDefense1FlinchTarget"
        chance = 50
      else
        chance = move.addlEffect
      end
      baseChance = chance
      showTera = terastal && battler.typeTeraBoosted?(type, true)
      bonus, power, acc, pri, chance = pbGetFinalModifiers(
        battler, move, type, basePower, power, acc, pri, chance, showTera)
      calcPower = power if power > basePower
      if power > 1
        if calcPower > basePower
          powBase, powShadow = BASE_RAISED, SHADOW_RAISED
        elsif power < (basePower * stab).floor
          powBase, powShadow = BASE_LOWERED, SHADOW_LOWERED
        end
      end
      if acc > 0
        if acc > move.accuracy
          accBase, accShadow = BASE_RAISED, SHADOW_RAISED
        elsif acc < move.accuracy
          accBase, accShadow = BASE_LOWERED, SHADOW_LOWERED
        end
      end
      if pri != 0
        if pri > move.priority
          priBase, priShadow = BASE_RAISED, SHADOW_RAISED
        elsif pri < move.priority
          priBase, priShadow = BASE_LOWERED, SHADOW_LOWERED
        end
      end
      if chance > 0
        if chance > baseChance
          effBase, effShadow = BASE_RAISED, SHADOW_RAISED
        elsif chance < baseChance
          effBase, effShadow = BASE_LOWERED, SHADOW_LOWERED
        end
      end
      #---------------------------------------------------------------------------
      # Draws text.
      textPos = []
      displayPower    = (power  == 0) ? "---" : (hidePower) ? "???" : power.ceil.to_s
      displayAccuracy = (acc    == 0) ? "---" : acc.ceil.to_s
      displayPriority = (pri    == 0) ? "---" : (pri > 0) ? "+" + pri.to_s : pri.to_s
      displayChance   = (chance == 0) ? "---" : chance.ceil.to_s + "%"
      textPos.push(
        [move.name,       xpos + 10,  ypos + 12, :left,   BASE_LIGHT, SHADOW_LIGHT, :outline],
        [_INTL("Pod:"),    xpos + 256, ypos + 40, :left,   BASE_LIGHT, SHADOW_LIGHT],
        [displayPower,    xpos + 309, ypos + 40, :center, powBase,    powShadow],
        [_INTL("Pre:"),    xpos + 348, ypos + 40, :left,   BASE_LIGHT, SHADOW_LIGHT],
        [displayAccuracy, xpos + 401, ypos + 40, :center, accBase,    accShadow],
        [_INTL("Pri:"),    xpos + 442, ypos + 40, :left,   BASE_LIGHT, SHADOW_LIGHT],
        [displayPriority, xpos + 484, ypos + 40, :center, priBase,    priShadow],
        [_INTL("Efe:"),    xpos + 428, ypos + 12, :left,   BASE_LIGHT, SHADOW_LIGHT],
        [displayChance,   xpos + 484, ypos + 12, :center, effBase,    effShadow]
      )
      textPos.push([bonus[0], xpos + 8, ypos + 132, :left, bonus[1], bonus[2], :outline]) if bonus
      pbDrawTextPositions(@enhancedUIOverlay, textPos)
      drawTextEx(@enhancedUIOverlay, xpos + 8, ypos + 74, Graphics.width - 12, 2, 
        move.description, BASE_LIGHT, SHADOW_LIGHT)
    end

    alias_method :zbox_updateBattlerInfo, :pbUpdateBattlerInfo
    def pbUpdateBattlerInfo(battler, effects, idxEffect = 0)
      @enhancedUIOverlay.clear
      pbUpdateBattlerIcons
      return if @enhancedUIToggle != :battler
      xpos = 28
      ypos = 24
      iconX = xpos + 28
      iconY = ypos + 62
      panelX = xpos + 240
      #---------------------------------------------------------------------------
      # General UI elements.
      poke = (battler.opposes?) ? battler.displayPokemon : battler.pokemon
      level = (battler.isRaidBoss?) ? "???" : battler.level.to_s
      movename = "---"
      if battler.lastMoveUsed
        last_move_object = battler.moves.find { |m| m.id == battler.lastMoveUsed }
        if last_move_object
          movename = last_move_object.name
        else
          movename = GameData::Move.get(battler.lastMoveUsed).name
        end
      end
      movename = movename[0..12] + "..." if movename.length > 16
      imagePos = [
        [@path + "info_bg", 0, 0],
        [@path + "info_bg_data", 0, 0],
        [@path + "info_level", xpos + 16, ypos + 106]
      ]
      imagePos.push([@path + "info_gender", xpos + 148, ypos + 22, poke.gender * 22, 0, 22, 22]) if !battler.isRaidBoss?
      textPos  = [
        [_INTL("{1}", poke.name), iconX + 82, iconY - 20, :center, BASE_DARK, SHADOW_DARK],
        [_INTL("{1}", level), xpos + 38, ypos + 104, :left, BASE_LIGHT, SHADOW_LIGHT],
        [_INTL("Usó: {1}", movename), xpos + 349, ypos + 104, :center, BASE_LIGHT, SHADOW_LIGHT],
        [_INTL("Turno {1}", @battle.turnCount + 1), Graphics.width - xpos - 32, ypos + 8, :center, BASE_DARK, SHADOW_DARK]
      ]
      #---------------------------------------------------------------------------
      # Battler icon.
      @battle.allBattlers.each do |b|
        @sprites["info_icon#{b.index}"].x = iconX
        @sprites["info_icon#{b.index}"].y = iconY
        @sprites["info_icon#{b.index}"].visible = (b.index == battler.index)
      end            
      #---------------------------------------------------------------------------
      # Owner
      if !battler.wild?
        imagePos.push([@path + "info_owner", xpos - 34, ypos + 6, 0, 20, 128, 20])
        textPos.push([@battle.pbGetOwnerFromBattlerIndex(battler.index).name, xpos + 32, ypos + 8, :center, BASE_DARK, SHADOW_DARK])
      end
      # Battler HP.
      if battler.hp > 0
        w = battler.hp * 96 / battler.totalhp.to_f
        w = 1 if w < 1
        w = ((w / 2).round) * 2
        hpzone = 0
        hpzone = 1 if battler.hp <= (battler.totalhp / 2).floor
        hpzone = 2 if battler.hp <= (battler.totalhp / 4).floor
        imagePos.push([@path + "info_hp", 86, 86, 0, hpzone * 6, w, 6])
      end
      # Battler status.
      if battler.status != :NONE
        iconPos = GameData::Status.get(battler.status).icon_position
        imagePos.push(["Graphics/UI/statuses", xpos + 86, ypos + 104, 0, iconPos * 16, 44, 16])
      end
      # Shininess
      imagePos.push(["Graphics/UI/shiny", xpos + 142, ypos + 102]) if poke.shiny?
      #---------------------------------------------------------------------------
      # Battler info for player-owned Pokemon.
      if battler.pbOwnedByPlayer?
        imagePos.push(
          [@path + "info_owner", xpos + 36, iconY + 10, 0, 0, 128, 20],
          [@path + "info_cursor", panelX, 62, 0, 0, 218, 26],
          [@path + "info_cursor", panelX, 86, 0, 0, 218, 26]
        )
        textPos.push(
          [_INTL("Hab."), xpos + 272, ypos + 44, :center, BASE_LIGHT, SHADOW_LIGHT],
          [_INTL("Obj."), xpos + 272, ypos + 68, :center, BASE_LIGHT, SHADOW_LIGHT],
          [_INTL("{1}", battler.abilityName), xpos + 376, ypos + 44, :center, BASE_DARK, SHADOW_DARK],
          [_INTL("{1}", battler.itemName), xpos + 376, ypos + 68, :center, BASE_DARK, SHADOW_DARK],
          [sprintf("%d/%d", battler.hp, battler.totalhp), iconX + 74, iconY + 12, :center, BASE_LIGHT, SHADOW_LIGHT]
        )
      end
      #---------------------------------------------------------------------------
      pbAddWildIconDisplay(xpos, ypos, battler, imagePos)
      pbAddStatsDisplay(xpos, ypos, battler, imagePos, textPos)
      pbDrawImagePositions(@enhancedUIOverlay, imagePos)
      pbDrawTextPositions(@enhancedUIOverlay, textPos)
      pbAddTypesDisplay(xpos, ypos, battler, poke)
      pbAddEffectsDisplay(xpos, ypos, panelX, effects, idxEffect)
    end      
  end
end

