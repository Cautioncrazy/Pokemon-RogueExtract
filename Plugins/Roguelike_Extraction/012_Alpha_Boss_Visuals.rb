#===============================================================================
# 012_Alpha_Boss_Visuals.rb
#===============================================================================

#===============================================================================
# System 1: The Core Hook (Bulletproof)
#===============================================================================
class Pokemon
  def isAlphaBoss?
    return true if self.respond_to?(:hp_boost) && self.hp_boost.is_a?(Numeric) && self.hp_boost > 1
    return true if self.respond_to?(:hp_level) && self.hp_level.is_a?(Numeric) && self.hp_level > 1
    return true if self.respond_to?(:is_boss?) && self.is_boss?
    return true if self.respond_to?(:has_immunity?) && self.has_immunity?(:RAIDBOSS)
    return true if self.respond_to?(:immunities) && self.immunities.is_a?(Array) && self.immunities.include?(:RAIDBOSS)
    return false
  end
end

class Battle::Battler
  def isAlphaBoss?
    return false if !self.pokemon
    return self.pokemon.isAlphaBoss?
  end
end

#===============================================================================
# System 2 & 3: The Drawing Module
#===============================================================================
module AlphaBossUIDrawer
  def calculate_alpha_boss_tiers
    boost = @battler.pokemon.hp_boost.to_i
    level = @battler.pokemon.hp_level.to_i
    level = 1 if level <= 0 # Prevent division by zero

    # Clamped to 6 max tiers since our graphic only has 6 slices
    total_tiers = (boost > 0) ? (boost / level).clamp(1, 6) : 1

    hp_per_tier = @battler.totalhp.to_f / total_tiers

    # Determine current tier (0-indexed. 0 is the final life)
    current_tier = (@battler.hp > 0) ? ((@battler.hp - 1) / hp_per_tier).to_i : 0

    return current_tier, total_tiers, hp_per_tier
  end

  def draw_alpha_boss_ui
    return unless @battler && @battler.opposes? && @battler.isAlphaBoss?
    return unless @hpBarBitmap && !@hpBarBitmap.disposed?

    current_tier, total_tiers, hp_per_tier = calculate_alpha_boss_tiers

    # Calculate HP remaining STRICTLY within the current tier
    hp_in_current_tier = @battler.hp - (current_tier * hp_per_tier)
    tier_hp_pct = hp_in_current_tier.to_f / hp_per_tier

    max_width = @hpBarBitmap.width
    bar_height = @hpBarBitmap.height / 6

    # The width of the active bar (will NEVER exceed max_width)
    fill_width = (max_width * tier_hp_pct).round
    fill_width = 1 if fill_width < 1 && @battler.hp > 0
    fill_width = ((fill_width / 2.0).round) * 2 # Snap to 2 pixels if needed by UI
    
    tier_to_index = { 0 => 2, 1 => 3, 2 => 4, 3 => 5, 4 => 5, 5 => 5 }
    active_index = tier_to_index[current_tier] || 5

    @hpBar.src_rect.width = fill_width
    @hpBar.src_rect.y = active_index * bar_height

    # Dynamic Redraw: If the tier crosses a boundary during animation, force a background redraw
    if @current_alpha_tier && @current_alpha_tier != current_tier && !@drawing_alpha_bg
      @current_alpha_tier = current_tier
      @drawing_alpha_bg = true
      self.refresh if self.respond_to?(:refresh)
      @drawing_alpha_bg = false
    else
      @current_alpha_tier = current_tier
    end
  end

  def draw_alpha_background
    return unless @battler && @battler.opposes? && @battler.isAlphaBoss?
    return unless @hpBarBitmap && !@hpBarBitmap.disposed?

    current_tier, total_tiers, hp_per_tier = calculate_alpha_boss_tiers

    tier_to_index = { 0 => 2, 1 => 3, 2 => 4, 3 => 5, 4 => 5, 5 => 5 }
    under_index = tier_to_index[current_tier - 1] || 0

    max_width = @hpBarBitmap.width
    bar_height = @hpBarBitmap.height / 6

    if current_tier > 0
      under_y_offset = under_index * bar_height
      under_rect = Rect.new(0, under_y_offset, max_width, bar_height)

      # Determine relative position of HP bar on the databox
      hp_x = @hpBar.x - self.x
      hp_y = @hpBar.y - self.y

      # Draw the lower-tier block. The slanted cutout of the databox image will mask it when drawn over.
      self.bitmap.blt(hp_x, hp_y, @hpBarBitmap.bitmap, under_rect)
    end
  end

  def sync_alpha_overlay
  end

  def draw_alpha_style_icons
    return unless @battler && @battler.opposes? && @battler.isAlphaBoss?
    filename = "Graphics/Plugins/Deluxe Battle Kit/Databoxes/alpha"
    return unless pbResolveBitmap(filename)

    if defined?(@displayPos) && @displayPos && @displayPos[:special]
      specialPos = @displayPos[:special]
      pbDrawImagePositions(self.bitmap, [[filename, specialPos[0] + 4, specialPos[1] + 4]])
    elsif defined?(@spriteBaseX)
      specialX = (@battler.opposes?(0)) ? 208 : -28
      specialY = 8
      pbDrawImagePositions(self.bitmap, [[filename, @spriteBaseX + specialX, specialY]])
    end
  end

  def dispose_alpha_overlay
  end
end

# 1. Inject into the Standard Databox
class Battle::Scene::PokemonDataBox < Sprite
  include AlphaBossUIDrawer

  alias alpha_dbk_draw_background draw_background
  def draw_background
    draw_alpha_background
    alpha_dbk_draw_background
  end
  
  alias alpha_dbk_refresh_hp refresh_hp
  def refresh_hp
    alpha_dbk_refresh_hp
    draw_alpha_boss_ui
  end

  alias alpha_dbk_update update
  def update
    alpha_dbk_update
    sync_alpha_overlay
  end

  alias alpha_dbk_dispose dispose
  def dispose
    alpha_dbk_dispose
    dispose_alpha_overlay
  end

  if method_defined?(:draw_style_icons)
    alias alpha_dbk_draw_style_icons draw_style_icons
    def draw_style_icons
      alpha_dbk_draw_style_icons
      draw_alpha_style_icons
    end
  elsif method_defined?(:draw_special_form_icon)
    alias alpha_dbk_draw_special_form_icon draw_special_form_icon
    def draw_special_form_icon
      alpha_dbk_draw_special_form_icon
      draw_alpha_style_icons
    end
  end
end

# 2. Inject directly into the massive DBK Boss Databox
if defined?(Battle::Scene::BossDataBox)
  class Battle::Scene::BossDataBox
    include AlphaBossUIDrawer
    
    alias alpha_dbk_boss_draw_background draw_background
    def draw_background
      draw_alpha_background
      alpha_dbk_boss_draw_background
    end

    alias alpha_dbk_boss_refresh_hp refresh_hp
    def refresh_hp
      alpha_dbk_boss_refresh_hp
      draw_alpha_boss_ui
    end

    alias alpha_dbk_boss_update update
    def update
      alpha_dbk_boss_update
      sync_alpha_overlay
    end

    alias alpha_dbk_boss_dispose dispose
    def dispose
      alpha_dbk_boss_dispose
      dispose_alpha_overlay
    end
  end
end

#===============================================================================
# System 4: Animated Sprite Overlay
#===============================================================================
class Sprite
  attr_accessor :alpha_pattern_type

  def apply_alpha_pattern(pokemon)
    path = Settings::DELUXE_GRAPHICS_PATH
    return if !pbResolveBitmap(path + "alpha_pattern")
    if pokemon && pokemon.isAlphaBoss?
      self.pattern.dispose if self.pattern && !self.pattern.disposed?
      self.pattern = Bitmap.new(path + "alpha_pattern")
      self.pattern_opacity = 150
      self.alpha_pattern_type = :alpha
    else
      self.pattern.dispose if self.pattern && !self.pattern.disposed?
      self.pattern = nil
      self.alpha_pattern_type = nil
    end
  end

  def set_alpha_pattern(pokemon)
    if pokemon && pokemon.isAlphaBoss?
      apply_alpha_pattern(pokemon)
    else
      if self.respond_to?(:pattern_type) && self.pattern_type == :shadow
        # Retain shadow pattern if present
      else
        self.pattern.dispose if self.pattern && !self.pattern.disposed?
        self.pattern = nil
        self.alpha_pattern_type = nil
      end
    end
  end

  def update_alpha_pattern
    return if self.alpha_pattern_type != :alpha
    if (System.uptime / 0.05).to_i % 2 == 0
      self.pattern_scroll_x += 1 if self.respond_to?(:pattern_scroll_x)
      self.pattern_scroll_y -= 1 if self.respond_to?(:pattern_scroll_y)
    end
  end
end

class Battle::Scene::BattlerSprite < RPG::Sprite
  alias alpha_vanilla_setPokemonBitmap setPokemonBitmap
  def setPokemonBitmap(*args)
    alpha_vanilla_setPokemonBitmap(*args)
    pokemon = args[0]
    self.set_alpha_pattern(pokemon) if pokemon && pokemon.isAlphaBoss?
  end

  alias alpha_update update
  def update
    alpha_update
    return if !@_iconBitmap
    self.update_alpha_pattern
  end
end