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
  def init_alpha_overlay
    # Create the Under-Bar on the exact same viewport so it inherits DBK's slanted mask
    if !@underHpBar
      @underHpBar = Sprite.new(@hpBar.viewport)
      @underHpBar.bitmap = Bitmap.new(@hpBar.bitmap.width, @hpBar.bitmap.height)
    end
    if !@infoHpBitmapAlpha
      @infoHpBitmapAlpha = AnimatedBitmap.new("Graphics/Plugins/Enhanced Battle UI/info_hp")
    end
  end

  def draw_alpha_boss_ui
    return unless @battler && @battler.opposes? && @battler.isAlphaBoss?

    init_alpha_overlay
    
    # Lock the Under-Bar exactly behind the active bar
    @underHpBar.x = @hpBar.x
    @underHpBar.y = @hpBar.y
    @underHpBar.z = @hpBar.z - 1
    @underHpBar.visible = true

    w_max = @hpBar.bitmap.width
    h_max = @hpBar.bitmap.height
    slice_height = @infoHpBitmapAlpha.height / 6
    dest_rect_full = Rect.new(0, 0, w_max, h_max)

    # Determine Tiers
    tier_count = (@battler.level / 20).to_i + 1
    if @battler.pokemon.respond_to?(:hp_boost) && @battler.pokemon.hp_boost.is_a?(Numeric) && @battler.pokemon.hp_boost > 1
      tier_count = @battler.pokemon.hp_boost
    end
    tier_count = [tier_count, 6].min

    pct = self.hp.to_f / @battler.totalhp.to_f
    current_tier = (pct * tier_count).ceil
    current_tier = 1 if current_tier < 1

    # 1. Draw Under-Bar (Always 100% width, never shrinks)
    @underHpBar.bitmap.clear
    if current_tier > 1
      under_index = [[6 - (current_tier - 1), 0].max, 5].min
      src_rect_under = Rect.new(0, under_index * slice_height, @infoHpBitmapAlpha.bitmap.width, slice_height)
      @underHpBar.bitmap.stretch_blt(dest_rect_full, @infoHpBitmapAlpha.bitmap, src_rect_under)
    end

    # 2. Draw Active-Bar directly onto the vanilla DBK canvas!
    # By drawing it full width, we preserve the gradient. DBK's engine will shrink the src_rect automatically.
    @hpBar.bitmap.clear
    active_index = [[6 - current_tier, 0].max, 5].min
    src_rect_active = Rect.new(0, active_index * slice_height, @infoHpBitmapAlpha.bitmap.width, slice_height)
    @hpBar.bitmap.stretch_blt(dest_rect_full, @infoHpBitmapAlpha.bitmap, src_rect_active)
    
    @hpBar.visible = true
  end

  def sync_alpha_overlay
    if @underHpBar && !@underHpBar.disposed?
      if @battler && @battler.opposes? && @battler.isAlphaBoss?
        @underHpBar.x = @hpBar.x
        @underHpBar.y = @hpBar.y
        @underHpBar.z = @hpBar.z - 1
        @underHpBar.visible = self.visible
        @underHpBar.opacity = self.opacity
        @underHpBar.color = self.color
      else
        @underHpBar.visible = false
      end
    end
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
    @underHpBar.dispose if @underHpBar
    @infoHpBitmapAlpha.dispose if @infoHpBitmapAlpha
  end
end

# 1. Inject into the Standard Databox
class Battle::Scene::PokemonDataBox < Sprite
  include AlphaBossUIDrawer
  
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