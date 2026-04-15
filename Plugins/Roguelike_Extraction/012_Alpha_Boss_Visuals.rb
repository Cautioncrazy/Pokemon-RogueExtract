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
  ALPHA_TIER_COLORS = [5, 4, 3, 2, 1, 0]

  def calculate_alpha_boss_tiers
    boost = @battler.pokemon.hp_boost.to_i

    # Simply use hp_boost, clamped to 6 max tiers since our graphic only has 6 slices
    total_tiers = (boost > 0) ? boost.clamp(1, 6) : 1

    hp_per_tier = @battler.totalhp.to_f / total_tiers

    # Use self.hp (visual tweened HP) instead of @battler.hp to prevent chunking
    current_visual_hp = self.hp

    # Determine current tier (0-indexed. 0 is the final life)
    current_tier = (current_visual_hp > 0) ? ((current_visual_hp - 1) / hp_per_tier).to_i : 0

    return current_tier, total_tiers, hp_per_tier, current_visual_hp
  end

  def draw_alpha_boss_ui
    return unless @battler && @battler.opposes? && @battler.isAlphaBoss?
    return unless @hpBarBitmap && !@hpBarBitmap.disposed?

    current_tier, total_tiers, hp_per_tier, current_visual_hp = calculate_alpha_boss_tiers

    # Calculate HP remaining STRICTLY within the current tier
    hp_in_current_tier = current_visual_hp - (current_tier * hp_per_tier)
    tier_hp_pct = hp_in_current_tier.to_f / hp_per_tier

    max_width = @hpBarBitmap.width
    bar_height = (@hpBarBitmap.bitmap.height / 6).to_i

    # The width of the active bar (will NEVER exceed max_width)
    fill_width = (max_width * tier_hp_pct).round
    fill_width = 1 if fill_width < 1 && current_visual_hp > 0
    fill_width = ((fill_width / 2.0).round) * 2 # Snap to 2 pixels if needed by UI
    
    active_index = ALPHA_TIER_COLORS[current_tier] || ALPHA_TIER_COLORS.last

    @hpBar.src_rect.width = fill_width
    @hpBar.src_rect.y = active_index * bar_height
    @hpBar.src_rect.height = bar_height

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

    current_tier, total_tiers, hp_per_tier, current_visual_hp = calculate_alpha_boss_tiers

    max_width = @hpBarBitmap.width
    bar_height = (@hpBarBitmap.bitmap.height / 6).to_i

    if current_tier > 0
      under_index = ALPHA_TIER_COLORS[current_tier - 1]
      under_y_offset = under_index * bar_height
      under_rect = Rect.new(0, under_y_offset, max_width, bar_height)

      # ONLY apply the rect if the sprite has been created by the timer
      @underBar.src_rect = under_rect if @underBar
    else
      @underBar.visible = false if @underBar && !@underBar.disposed?
    end
  end

  def force_alpha_hp_height
    return unless @battler && @battler.opposes? && @battler.isAlphaBoss?
    return unless @hpBarBitmap && !@hpBarBitmap.disposed?

    bar_height = (@hpBarBitmap.bitmap.height / 6).to_i

    @hpBar.src_rect.height = bar_height if @hpBar
    @underBar.src_rect.height = bar_height if @underBar
  end

  def sync_alpha_overlay
    force_alpha_hp_height # The crucial failsafe

    # 1. Delayed Creation Logic ("Dial-in" delay)
    @alpha_creation_timer ||= 0
    creation_delay = 1200 # <-- Adjust this to match DBK's slide-in duration

    if @alpha_creation_timer < creation_delay
      @alpha_creation_timer += 1
    elsif !@underBar && @hpBar && !@hpBar.disposed? && @current_alpha_tier && @current_alpha_tier > 0
      # Timer finished! Instantiate the under-bar safely after the UI settles.
      @underBar = Sprite.new(@hpBar.viewport)
      @underBar.bitmap = @hpBarBitmap.bitmap

      # Force an immediate src_rect update so it doesn't render wrong on frame 1
      max_width = @hpBarBitmap.width
      bar_height = (@hpBarBitmap.bitmap.height / 6).to_i
      under_index = ALPHA_TIER_COLORS[@current_alpha_tier - 1]
      @underBar.src_rect = Rect.new(0, under_index * bar_height, max_width, bar_height)
    end

    # 2. Continuous Syncing Logic (Only runs after creation)
    if @underBar && @hpBar && !@hpBar.disposed?
      @underBar.x = @hpBar.x
      @underBar.y = @hpBar.y
      @underBar.z = @hpBar.z - 1

      @underBar.opacity = self.opacity
      @underBar.color = self.color if self.respond_to?(:color)

      # Failsafe: Hide entirely if it's the final life, dead, or the main UI is hidden
      if @current_alpha_tier == 0 || self.hp <= 0 || !@hpBar.visible || !self.visible
        @underBar.visible = false
      else
        @underBar.visible = true
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
    @underBar.dispose if @underBar && !@underBar.disposed?
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

  if method_defined?(:animateHP)
    alias alpha_dbk_animateHP animateHP
    def animateHP(*args)
      alpha_dbk_animateHP(*args)
      force_alpha_hp_height
    end
  end

  alias alpha_dbk_opacity_set opacity=
  def opacity=(value)
    alpha_dbk_opacity_set(value)
    @underBar.opacity = value if @underBar
  end

  alias alpha_dbk_visible_set visible=
  def visible=(value)
    alpha_dbk_visible_set(value)
    if @underBar
      # Only force hide if main UI hides; let sync handle the reveal
      @underBar.visible = false if !value || !@hpBar || !@hpBar.visible
    end
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

class Battle::Scene::BattlerSprite < RPG::Sprite
  unless method_defined?(:alpha_vanilla_setPokemonBitmap)
    alias alpha_vanilla_setPokemonBitmap setPokemonBitmap
  end
  def setPokemonBitmap(pkmn, back = false)
    alpha_vanilla_setPokemonBitmap(pkmn, back)
    self.set_plugin_pattern(pkmn) if self.respond_to?(:set_plugin_pattern)
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

    if method_defined?(:animateHP)
      alias alpha_dbk_boss_animateHP animateHP
      def animateHP(*args)
        alpha_dbk_boss_animateHP(*args)
        force_alpha_hp_height
      end
    end

    alias alpha_dbk_boss_opacity_set opacity=
    def opacity=(value)
      alpha_dbk_boss_opacity_set(value)
      @underBar.opacity = value if @underBar
    end

    alias alpha_dbk_boss_visible_set visible=
    def visible=(value)
      alpha_dbk_boss_visible_set(value)
      if @underBar
        @underBar.visible = false if !value || !@hpBar || !@hpBar.visible
      end
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
      self.pattern_type = :alpha # Overwrite DBK's pattern_type
      self.alpha_pattern_type = :alpha
    else
      self.pattern.dispose if self.pattern && !self.pattern.disposed?
      self.pattern = nil
      self.pattern_type = nil
      self.alpha_pattern_type = nil
    end
  end

  def set_alpha_pattern(pokemon)
    if pokemon && pokemon.isAlphaBoss?
      apply_alpha_pattern(pokemon)
    elsif self.respond_to?(:pattern_type) && self.pattern_type == :shadow
      # DBK Shadow already applied, do nothing
      self.alpha_pattern_type = nil
    else
      self.pattern.dispose if self.pattern && !self.pattern.disposed?
      self.pattern = nil
      self.pattern_type = nil
      self.alpha_pattern_type = nil
    end
  end

  def update_alpha_pattern
    return if self.alpha_pattern_type != :alpha
    if (System.uptime / 0.05).to_i % 2 == 0
      self.pattern_scroll_x += 1 if self.respond_to?(:pattern_scroll_x)
      self.pattern_scroll_y -= 1 if self.respond_to?(:pattern_scroll_y)
    end
  end

  # Hook into DBK's pattern system
  if method_defined?(:set_plugin_pattern)
    alias alpha_set_plugin_pattern set_plugin_pattern
    def set_plugin_pattern(pokemon, override = false)
      alpha_set_plugin_pattern(pokemon, override)
      set_alpha_pattern(pokemon)
    end
  end

  if method_defined?(:set_plugin_icon_pattern)
    alias alpha_set_plugin_icon_pattern set_plugin_icon_pattern
    def set_plugin_icon_pattern
      alpha_set_plugin_icon_pattern
      set_alpha_pattern(self.pokemon) if self.respond_to?(:pokemon)
    end
  end

  if method_defined?(:update_plugin_pattern)
    alias alpha_update_plugin_pattern update_plugin_pattern
    def update_plugin_pattern
      alpha_update_plugin_pattern
      update_alpha_pattern
    end
  end
end