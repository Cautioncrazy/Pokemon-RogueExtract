#==============================================================================
# ** Parche para Movimientos Personalizados **
# ** Patch for Custom Moves **
#==============================================================================

class Pokemon
  class Move
    # Se define un mapa para traducir nuestras claves a los nombres de los métodos de display.
    # A map is defined to translate our keys to the display method names.
    ZBOX_PKMN_MOVE_MAP = {
      :power    => :display_damage,
      :accuracy => :display_accuracy,
      :type     => :display_type,
      :category => :display_category,
      :name        => :name,
      :total_pp    => :total_pp,
      :description => :description
    }

    ZBOX_PKMN_MOVE_MAP.each do |simple_key, method_name|
      next unless method_defined?(method_name) || private_method_defined?(method_name)
      
      alias_method "zbox_original_pkmn_move_#{simple_key}", method_name

      define_method(method_name) do |*args|
        # Se necesita una referencia al Pokémon dueño.
        # A reference to the owner Pokémon is needed.
        if $player
          pkmn = args.first
          if !pkmn.is_a?(Pokemon)
            $player.party.each do |p|
              next unless p && p.moves.include?(self)
              pkmn = p
              break
            end
          end
        end

        if pkmn&.respond_to?(:zbox_move_mods) && pkmn.zbox_move_mods&.key?(@id)
          mods = pkmn.zbox_move_mods[@id]
          if mods.key?(simple_key)
            modified_value = mods[simple_key]
            if simple_key == :type
              return GameData::Type.get(modified_value).id
            elsif simple_key == :category
              return 0 if modified_value == :PHYSICAL
              return 1 if modified_value == :SPECIAL
              return 2 if modified_value == :STATUS
            elsif simple_key == :total_pp
              base_pp = modified_value
              return base_pp + (base_pp * @ppup / 5)
            end
            return modified_value
          end
        end
        return send("zbox_original_pkmn_move_#{simple_key}", *args)
      end
    end
  end
end

# --- Para el cálculo en Batalla ---
# --- For in-battle calculation ---
class Battle::Move

  def description
    return @realMove.description
  end

  # Se define un mapa para traducir nuestras claves a los métodos de cálculo de batalla.
  # A map is defined to translate our keys to the battle calculation methods.
  ZBOX_BATTLE_MAP = {         
    :power    => :pbBaseDamage,
    :accuracy => :pbBaseAccuracy,
    :type     => :pbBaseType,
    :priority => :pbPriority,    
    :name     => :name,
    :total_pp => :total_pp
  }

  ZBOX_BATTLE_MAP.each do |simple_key, method_name|
    next unless method_defined?(method_name) || private_method_defined?(method_name)
    
    alias_method "zbox_original_battle_#{simple_key}", method_name

    define_method(method_name) do |*args|
      # Se busca el primer argumento que sea un objeto Battler.
      # The first argument that is a Battler object is found.
      user = args.find { |arg| arg.is_a?(Battle::Battler) }
      user ||= @battle.battlers.find { |b| b && b.moves.include?(self) }
      
      if user && user.pokemon&.respond_to?(:zbox_move_mods) && user.pokemon.zbox_move_mods&.key?(@id)
        mods = user.pokemon.zbox_move_mods[@id]
        if mods.key?(simple_key)
          modified_value = mods[simple_key]
          if simple_key == :type
            return GameData::Type.get(modified_value).id
          end
          return modified_value
        end
      end

      if method_name == :pbBaseDamage
        if args.length == 2
          return send("zbox_original_battle_#{simple_key}", @power, *args)
        end
      end

      return send("zbox_original_battle_#{simple_key}", *args)
    end
  end

  # Se guarda una referencia a los métodos originales.
  # A reference to the original methods is kept.
  alias_method :zbox_original_physicalMove?, :physicalMove?
  alias_method :zbox_original_specialMove?, :specialMove?
  alias_method :zbox_original_statusMove?, :statusMove?

  def zbox_get_custom_category
    # Se busca al usuario del movimiento en el campo de batalla.
    # Se busca al usuario del movimiento en el campo de batalla.
    user = @battle.battlers.find { |b| b && b.moves.include?(self) }
    return nil unless user && user.pokemon
    
    user_pkmn = user.pokemon
    # Se comprueba si el Pokémon tiene modificaciones para este movimiento.
    # Checks if the Pokémon has any modifications for this move.
    if user_pkmn.respond_to?(:zbox_move_mods) && user_pkmn.zbox_move_mods&.key?(@id)
      mods = user_pkmn.zbox_move_mods[@id]
      if mods.key?(:category)
        case mods[:category]
        when :PHYSICAL then return 0
        when :SPECIAL  then return 1
        when :STATUS   then return 2
        end
      end
    end
    return nil
  end

  def physicalMove?(thisType = nil)
    custom_category = zbox_get_custom_category
    # Si hay una categoría personalizada, se usa. Si no, se llama al método original.
    # If there is a custom category, it is used. If not, the original method is called.
    return custom_category == 0 unless custom_category.nil?
    return zbox_original_physicalMove?(thisType)
  end

  def specialMove?(thisType = nil)
    custom_category = zbox_get_custom_category
    return custom_category == 1 unless custom_category.nil?
    return zbox_original_specialMove?(thisType)
  end

  def statusMove?(thisType = nil)
    custom_category = zbox_get_custom_category
    return custom_category == 2 unless custom_category.nil?
    return zbox_original_statusMove?
  end  
end

#==============================================================================
# ** Parche para Efectos de Movimientos Personalizados **
# ** Patch for Custom Moves Effects **
#==============================================================================

module ZBox
  class StatusEffectInterpreter
    def initialize(effect_hash)
      @effects = effect_hash
    end

    def execute_per_target(user, target, battle, move)
      
      if @effects[:stat_changes_target]
        show_anim_raise = true
        show_anim_lower = true
        @effects[:stat_changes_target].each do |stat, increment|
          if increment > 0
            # Aumentar estadística del objetivo
            # Increase target stats
            if target.pbCanRaiseStatStage?(stat, user, move)
              if target.pbRaiseStatStage(stat, increment, user, show_anim_raise)
                show_anim_raise = false
              end
            end
          elsif increment < 0
            # Bajar estadística del objetivo
            # Lower target stats
            if target.pbCanLowerStatStage?(stat, user, move)
              if target.pbLowerStatStage(stat, -increment, user, show_anim_lower)
                show_anim_lower = false
              end
            end
          end
        end
      end

      # --- Aplicar Estado/Efecto al Objetivo ---
      # --- Apply State/Effect to Target ---
      if @effects[:apply_status_to_target]
        effects_to_apply = [@effects[:apply_status_to_target]].flatten(1)
        
        effects_to_apply.each do |effect_data|
          status, chance = effect_data
          chance ||= 100

          if battle.pbRandom(100) < chance
            case status
            when :SLEEP
              target.pbSleep if target.pbCanSleep?(user, true, move)
            when :POISON
              target.pbPoison(user) if target.pbCanPoison?(user, true, move)
            when :BURN
              target.pbBurn(user) if target.pbCanBurn?(user, true, move)
            when :PARALYSIS
              target.pbParalyze(user) if target.pbCanParalyze?(user, true, move)
            when :FROZEN
              target.pbFreeze if target.pbCanFreeze?(user, true, move)
            when :CONFUSION
              target.pbConfuse if target.pbCanConfuse?(user, true, move)
            when :ATTRACTION
              target.pbAttract(user) if target.pbCanAttract?(user, true)
            when :FLINCH
              target.pbFlinch(user)
            end
          end
        end
      end

      # --- Curar al Objetivo ---
      # --- Heal Target ---
      if @effects[:heal_target]
        if target.canHeal?
          amount = @effects[:heal_target]
          # Si el valor es menor que 2 (ej. 0.5), se interpreta como un porcentaje del HP máximo.
          # If the value is less than 2 (e.g., 0.5), it's interpreted as a percentage of max HP.
          hp_to_heal = (amount < 2) ? (target.totalhp * amount).round : amount
          target.pbRecoverHP(hp_to_heal)
          battle.pbDisplay(_INTL("¡Los PS de {1} han sido restaurados!", target.pbThis(true)))
        end
      end

      # --- Deshabilitar el Último Movimiento del Objetivo ---
      # --- Disable Target's Last Move ---
      if @effects[:disable_target_last_move]
        duration = @effects[:disable_target_last_move].is_a?(Numeric) ? @effects[:disable_target_last_move] : 4
        
        if target.lastRegularMoveUsed && target.effects[PBEffects::Disable] == 0
          can_disable = false
          target.eachMove do |m|
            next if m.id != target.lastRegularMoveUsed
            can_disable = (m.pp > 0 || m.total_pp == 0)
            break
          end
          
          if can_disable
            target.effects[PBEffects::Disable]     = duration
            target.effects[PBEffects::DisableMove] = target.lastRegularMoveUsed
            battle.pbDisplay(_INTL("¡El movimiento {2} de {1} ha sido anulado!", target.pbThis(true),
                                   GameData::Move.get(target.lastRegularMoveUsed).name))
            target.pbItemStatusCureCheck
          end
        end
      end
      
      # --- Suprimir la Habilidad del Objetivo ---
      # --- Suppress Target's Ability ---
      if @effects[:suppress_target_ability]
        if !target.unstoppableAbility? && target.effects[PBEffects::GastroAcid] == false
          target.effects[PBEffects::GastroAcid] = true
          target.effects[PBEffects::Truant]     = false
          battle.pbDisplay(_INTL("¡La habilidad de {1} ha sido anulada!", target.pbThis(true)))
          target.pbOnLosingAbility(target.ability, true)
        end
      end
      
      # --- Cambiar la Habilidad del Objetivo ---
      # --- Change Target's Ability ---
      if @effects[:change_target_ability]
        new_ability_id = @effects[:change_target_ability]
        new_ability = GameData::Ability.try_get(new_ability_id)
        
        if new_ability && !target.unstoppableAbility? && target.ability_id != new_ability_id
          battle.pbShowAbilitySplash(target, true, false)
          old_abil = target.ability
          target.ability = new_ability.id
          battle.pbReplaceAbilitySplash(target)
          battle.pbDisplay(_INTL("¡La habilidad de {1} ha cambiado a {2}!", target.pbThis(true), new_ability.name))
          battle.pbHideAbilitySplash(target)
          target.pbOnLosingAbility(old_abil)
          target.pbTriggerAbilityOnGainingIt
        end
      end
    end

    def execute(user, battle, move)
      # --- Aplicar Cambios de Estadísticas ---
      # --- Apply Statistics Changes ---
      if @effects[:stat_changes]
        show_anim_raise = true
        show_anim_lower = true
        @effects[:stat_changes].each do |stat, increment|
          if increment > 0
            # Aumentar estadística
            # Increase statistics
            if user.pbCanRaiseStatStage?(stat, user, move)
              if user.pbRaiseStatStage(stat, increment, user, show_anim_raise)
                show_anim_raise = false
              end
            end
          elsif increment < 0
            # Bajar estadística
            # Lower statistics
            if user.pbCanLowerStatStage?(stat, user, move)
              if user.pbLowerStatStage(stat, -increment, user, show_anim_lower)
                show_anim_lower = false
              end
            end
          end
        end
      end

      # --- Aplicar Estado al Usuario ---
      # --- Apply Status to User ---
      if @effects[:apply_status_to_user]
        status, chance = @effects[:apply_status_to_user]
        chance ||= 100 # 100% default probability
        if battle.pbRandom(100) < chance
          case status
          when :SLEEP
            user.pbSleepSelf if user.pbCanSleep?(user, false, move, true)
          when :POISON
            user.pbPoison(user) if user.pbCanPoison?(user, false, move)
          when :BURN
            user.pbBurn(user) if user.pbCanBurn?(user, false, move)
          when :PARALYSIS
            user.pbParalyze(user) if user.pbCanParalyze?(user, false, move)
          when :FROZEN
            user.pbFreeze if user.pbCanFreeze?(user, false, move)
          when :CONFUSION
            user.pbConfuse if user.pbCanConfuseSelf?(false)
          when :ATTRACTION
            # Para la atracción, necesita un objetivo del cual enamorarse.
            # Se elige un oponente aleatorio.
            # For attraction, it needs a target to be attracted to.
            # A random opponent is chosen.
            target = user.pbDirectOpposing(true)
            user.pbAttract(target) if target && user.pbCanAttract?(target, false)
          when :FLINCH
            user.pbFlinch(user)
          end
        end
      end

      # --- Cambiar el Clima ---
      # --- Change the Climate ---
      if @effects[:change_weather]
        weather, duration = @effects[:change_weather]
        duration ||= 5  
        if battle.field.weather != weather
          battle.pbStartWeather(user, weather, true)
          if battle.field.weatherDuration > 0 
            new_duration = duration
            if user.itemActive?
              new_duration = Battle::ItemEffects.triggerWeatherExtender(user.item, weather, new_duration, user, battle)
            end
            battle.field.weatherDuration = new_duration
          end
        end
      end
      
      # --- Cambiar el Terreno ---
      # --- Changing the Terrain ---
      if @effects[:change_terrain]
        terrain, duration = @effects[:change_terrain]
        duration ||= 5       
        if battle.field.terrain != terrain
          battle.pbStartTerrain(user, terrain, true)
          if battle.field.terrainDuration > 0 
            new_duration = duration
            if user.itemActive?
              new_duration = Battle::ItemEffects.triggerTerrainExtender(user.item, terrain, new_duration, user, battle)
            end
            battle.field.terrainDuration = new_duration
          end
        end
      end
      
      # --- Añadir Entry Hazards al Lado del Oponente ---
      # --- Add Entry Hazards to Opponent's Side ---
      if @effects[:add_hazards_to_target_side]
        hazards_data = [@effects[:add_hazards_to_target_side]].flatten
        target_side = user.pbOpposingSide
      
        hazards_data.each do |data|
        hazard = data.is_a?(Hash) ? data[:hazard] : data
        message = data.is_a?(Hash) ? data[:message] : nil
        
        case hazard
        when :STEALTHROCK
          if !target_side.effects[PBEffects::StealthRock]
            target_side.effects[PBEffects::StealthRock] = true
            battle.pbAnimation(:STEALTHROCK, user, nil)
            default_msg = _INTL("¡Hay rocas puntiagudas flotando alrededor de {1}!", user.pbOpposingTeam(true))
            battle.pbDisplay(message ? _INTL(message, user.pbOpposingTeam(true)) : default_msg)
          end
        when :SPIKES
          if target_side.effects[PBEffects::Spikes] < 3
            target_side.effects[PBEffects::Spikes] += 1
            battle.pbAnimation(:SPIKES, user, nil)
            default_msg = _INTL("¡Hay púas esparcidas a los pies de {1}!", user.pbOpposingTeam(true))
            battle.pbDisplay(message ? _INTL(message, user.pbOpposingTeam(true)) : default_msg)
          end
        when :TOXICSPIKES
          if target_side.effects[PBEffects::ToxicSpikes] < 2
            target_side.effects[PBEffects::ToxicSpikes] += 1
            battle.pbAnimation(:TOXICSPIKES, user, nil)
            default_msg = _INTL("¡Hay púas venenosas esparcidas a los pies de {1}!", user.pbOpposingTeam(true))
            battle.pbDisplay(message ? _INTL(message, user.pbOpposingTeam(true)) : default_msg)
          end
        when :STICKYWEB
          if !target_side.effects[PBEffects::StickyWeb]
            target_side.effects[PBEffects::StickyWeb] = true
            battle.pbAnimation(:STICKYWEB, user, nil)
            default_msg = _INTL("¡Una red pegajosa se extiende a los pies de {1}!", user.pbOpposingTeam(true))
            battle.pbDisplay(message ? _INTL(message, user.pbOpposingTeam(true)) : default_msg)
          end
        end
      end
        
      # --- Añadir Efectos de Lado al Lado del Usuario ---
      # --- Add Side-by-Side Effects for User ---
      if @effects[:add_side_effect_to_user]
          effects_data = [@effects[:add_side_effect_to_user]].flatten
          user_side = user.pbOwnSide
          
          effects_data.each do |data|
            effect = data.is_a?(Hash) ? data[:effect] : data
            # Se obtiene la duración del hash, o se usa 5 por defecto.
            # The hash duration is obtained, or 5 is used by default.
            duration = data.is_a?(Hash) ? data[:duration] : 5
            duration ||= 5
            message = data.is_a?(Hash) ? data[:message] : nil
          
            case effect
            when :TAILWIND
              if user_side.effects[PBEffects::Tailwind] == 0
                user_side.effects[PBEffects::Tailwind] = duration
                battle.pbAnimation(:TAILWIND, user, nil)
                default_msg = _INTL("¡El viento afín sopla a favor de {1}!", user.pbTeam(true))
                battle.pbDisplay(message ? _INTL(message, user.pbTeam(true)) : default_msg)
              end
            when :REFLECT
              if user_side.effects[PBEffects::Reflect] == 0
                final_duration = (user.hasActiveItem?(:LIGHTCLAY)) ? (duration * 1.6).round : duration
                user_side.effects[PBEffects::Reflect] = final_duration
                battle.pbAnimation(:REFLECT, user, nil)
                default_msg = _INTL("¡Reflejo ha fortalecido la defensa de {1}!", user.pbTeam(true))
                battle.pbDisplay(message ? _INTL(message, user.pbTeam(true)) : default_msg)
              end
            when :LIGHTSCREEN
              if user_side.effects[PBEffects::LightScreen] == 0
                final_duration = (user.hasActiveItem?(:LIGHTCLAY)) ? (duration * 1.6).round : duration
                user_side.effects[PBEffects::LightScreen] = final_duration
                battle.pbAnimation(:LIGHTSCREEN, user, nil)
                default_msg = _INTL("¡Pantalla de Luz ha fortalecido la defensa especial de {1}!", user.pbTeam(true))
                battle.pbDisplay(message ? _INTL(message, user.pbTeam(true)) : default_msg)
              end
            when :AURORAVEIL
              if user.effectiveWeather == :Hail && user_side.effects[PBEffects::AuroraVeil] == 0
                final_duration = (user.hasActiveItem?(:LIGHTCLAY)) ? (duration * 1.6).round : duration
                user_side.effects[PBEffects::AuroraVeil] = final_duration
                battle.pbAnimation(:AURORAVEIL, user, nil)
                default_msg = _INTL("¡Un velo protege a {1} de los ataques!", user.pbTeam(true))
                battle.pbDisplay(message ? _INTL(message, user.pbTeam(true)) : default_msg)
              end
            when :SAFEGUARD
              if user_side.effects[PBEffects::Safeguard] == 0
                user_side.effects[PBEffects::Safeguard] = duration
                battle.pbAnimation(:SAFEGUARD, user, nil)
                default_msg = _INTL("¡{1} se ha protegido con un velo misterioso!", user.pbTeam(true))
                battle.pbDisplay(message ? _INTL(message, user.pbTeam(true)) : default_msg)
              end
            when :MIST
              if user_side.effects[PBEffects::Mist] == 0
                user_side.effects[PBEffects::Mist] = duration
                battle.pbAnimation(:MIST, user, nil)
                default_msg = _INTL("¡Una neblina ha envuelto a {1} y lo protege de bajadas de características!", user.pbTeam(true))
                battle.pbDisplay(message ? _INTL(message, user.pbTeam(true)) : default_msg)
              end
            end
          end
        end
      end

      # --- Daño de retroceso ---
      # --- Recoil Damage ---
      if @effects[:recoil_user]
        if user.takesIndirectDamage?
          amount = @effects[:recoil_user]
          hp_to_lose = (amount < 2) ? (user.totalhp * amount).round : amount
          hp_to_lose = [hp_to_lose, user.hp - 1].min if hp_to_lose >= user.hp
          
          if hp_to_lose > 0
            battle.scene.pbDamageAnimation(user)
            user.pbReduceHP(hp_to_lose, false)
            battle.pbDisplay(_INTL("¡{1} también se ha hecho daño!", user.pbThis))
            user.pbItemHPHealCheck
          end
        end
      end
      
      # --- Curar al Usuario ---
      # --- Cure the User ---
      if @effects[:heal_user]
        if user.canHeal?
          amount = @effects[:heal_user]
          hp_to_heal = (amount < 2) ? (user.totalhp * amount).round : amount
          user.pbRecoverHP(hp_to_heal)
          battle.pbDisplay(_INTL("¡Los PS de {1} han sido restaurados!", user.pbThis(true)))
        end
      end
      
      user.pbFaint if user.fainted?
    end
  end
end

class Battle::Move
  alias_method :zbox_factory_initialize, :initialize
  def initialize(battle, move)
    zbox_factory_initialize(battle, move)
    
    user = battle.battlers.find { |b| b && b.pokemon.moves.include?(move) }
    return unless user && user.pokemon
    
    user_pkmn = user.pokemon
    if user_pkmn.respond_to?(:zbox_move_mods) && user_pkmn.zbox_move_mods&.key?(@id)
      mods = user_pkmn.zbox_move_mods[@id]
      
      if mods.key?(:name)
        @name = mods[:name]
      end

      if mods.key?(:target)
        new_target = GameData::Target.try_get(mods[:target])
        if new_target
          @target = new_target.id
        end
      end
      
      if mods.key?(:status_effect) && mods[:status_effect].is_a?(Hash) && mods[:status_effect][:fixed_damage_target]
        fixed_damage_amount = mods[:status_effect][:fixed_damage_target]
        
        # Se redefine el método de cálculo de daño para esta instancia.
        # The damage calculation method is redefined for this instance.
        define_singleton_method(:pbCalcDamage) do |user, target, numTargets = 1|
          target.damageState.critical = false
          target.damageState.calcDamage = fixed_damage_amount
        end
      end

      if mods.key?(:status_effect) && mods[:status_effect].is_a?(Hash)
        interpreter = ZBox::StatusEffectInterpreter.new(mods[:status_effect])

        define_singleton_method(:pbOnStartUse) do |user, targets|
          effect_hash = mods[:status_effect]
          
          # Mensaje para movimientos dirigidos a un objetivo
          # Message for goal-directed movements
          if effect_hash[:message] && !@zbox_message_shown
            @battle.pbDisplay(_INTL(effect_hash[:message], user.pbThis))
            @zbox_message_shown = true
          end
          
          #NOTA: Realmente no hay diferencia entre uno y otro.
          #NOTE: There is really no difference between the two.

          # Mensaje para movimientos centrados en el usuario
          # Message for user-centered movements
          if effect_hash[:message_user]
            @battle.pbDisplay(_INTL(effect_hash[:message_user], user.pbThis))
          end
        end
        
        # Redefine pbEffectGeneral para los efectos que solo ocurren una vez (sobre el usuario).
        # Redefine pbEffectGeneral for effects that only occur once (on the user).
        define_singleton_method(:pbEffectGeneral) do |user|
          interpreter.execute(user, @battle, self)
        end
        
        # Redefine pbEffectAgainstTarget para los efectos que se aplican a cada objetivo.
        # Redefine pbEffectAgainstTarget for the effects that are applied to each target.
        define_singleton_method(:pbEffectAgainstTarget) do |user, target|
          interpreter.execute_per_target(user, target, @battle, self)
        end
      end
    end
  end
end