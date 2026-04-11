#===============================================================================
# 012_Alpha_Boss_Visuals.rb
# Handles all visual UI representations of Alpha Bosses in combat.
# System 1: Core Hook
# System 2: Multi-Tier HP Bar
# System 3: Databox Icon
# System 4: Animated Sprite Overlay
#===============================================================================

#===============================================================================
# System 1: The Core Hook
#===============================================================================
class Battle::Battler
  def isAlphaBoss?
    return self.isRaidBoss?
  end
end

#===============================================================================
# System 2 & 3: Multi-Tier HP Bar & Databox Icon
#===============================================================================
class Battle::Scene::PokemonDataBox < Sprite

  # Override refresh_hp to draw the Multi-Tier HP Bar
  alias alpha_dbk_refresh_hp refresh_hp
  def refresh_hp
    alpha_dbk_refresh_hp

    return if !@battler || !@battler.pokemon || !@battler.isAlphaBoss?

    @hpNumbers.bitmap.clear if @show_hp_numbers && @hpNumbers

    # Hide the default EBUI/DBK hp bar graphic
    @hpBar.visible = false

    # Generate the custom info_hp overlay
    unless @alphaHpOverlay
      @alphaHpOverlay = Sprite.new(@viewport)
      @alphaHpOverlay.z = @hpBar.z + 1
      # Load the specific 6-slice info_hp.png from Enhanced Battle UI graphics
      @infoHpBitmap = AnimatedBitmap.new("Graphics/Plugins/Enhanced Battle UI/info_hp")

      slice_height = @infoHpBitmap.height / 6
      # Create a canvas matching the HP Bar width and 1/6th of info_hp height
      @alphaHpOverlay.bitmap = Bitmap.new(@hpBarBitmap.width, slice_height)
    end

    slice_height = @infoHpBitmap.height / 6

    # Determine dynamic tier count using native DBK stats
    tier_count = 1
    if @battler.pokemon.respond_to?(:hp_boost) && @battler.pokemon.hp_boost.is_a?(Numeric) && @battler.pokemon.hp_boost > 1
      tier_count = @battler.pokemon.hp_boost
    elsif @battler.pokemon.respond_to?(:hp_level) && @battler.pokemon.hp_level.is_a?(Numeric) && @battler.pokemon.hp_level > 1
      tier_count = @battler.pokemon.hp_level
    end

    # Cap maximum number of graphical tiers to the 6 slices we have
    tier_count = [tier_count, 6].min

    # Math for tiers
    pct = self.hp.to_f / @battler.totalhp.to_f
    current_tier = (pct * tier_count).ceil
    current_tier = 1 if current_tier < 1

    tier_pct = (pct * tier_count) - (current_tier - 1)

    w = @hpBarBitmap.width.to_f * tier_pct
    w = 1 if w < 1 && self.hp > 0
    w = ((w / 2.0).round) * 2
    w = @hpBarBitmap.width if w > @hpBarBitmap.width

    @alphaHpOverlay.x = @hpBar.x
    @alphaHpOverlay.y = @hpBar.y
    @alphaHpOverlay.bitmap.clear

    # Map tier index to info_hp.png slice.
    # The lowest HP tier (Tier 1) corresponds to the red slice, which is index 2.
    # Higher tiers cycle up through the newly added slices (indices 3, 4, 5)
    # and then wrap back if the boss has more than 4 tiers.
    slice_indices = [2, 3, 4, 5, 0, 1]

    # Draw the "Under-Bar" (full width of the previous tier)
    if current_tier > 1
      under_index = slice_indices[(current_tier - 2) % slice_indices.length]
      @alphaHpOverlay.bitmap.blt(0, 0, @infoHpBitmap.bitmap, Rect.new(0, under_index * slice_height, @hpBarBitmap.width, slice_height))
    end

    # Draw the "Active Bar" (scaled width of the current tier)
    active_index = slice_indices[(current_tier - 1) % slice_indices.length]
    @alphaHpOverlay.bitmap.blt(0, 0, @infoHpBitmap.bitmap, Rect.new(0, active_index * slice_height, w, slice_height))

    @alphaHpOverlay.visible = self.visible
  end

  # System 3: The Databox Icon
  if method_defined?(:draw_style_icons)
    alias alpha_dbk_draw_style_icons draw_style_icons
    def draw_style_icons
      alpha_dbk_draw_style_icons
      if @battler && @battler.isAlphaBoss?
        specialPos = @displayPos[:special]
        filename = "Graphics/Plugins/Deluxe Battle Kit/Databoxes/alpha"
        if pbResolveBitmap(filename)
          # Position it immediately to the right of the HP Bar
          pbDrawImagePositions(self.bitmap, [[filename, specialPos[0] + 4, specialPos[1] + 4]])
        end
      end
    end
  elsif method_defined?(:draw_special_form_icon)
    alias alpha_dbk_draw_special_form_icon draw_special_form_icon
    def draw_special_form_icon
      alpha_dbk_draw_special_form_icon
      if @battler && @battler.isAlphaBoss?
        specialX = (@battler.opposes?(0)) ? 208 : -28
        specialY = 8
        filename = "Graphics/Plugins/Deluxe Battle Kit/Databoxes/alpha"
        if pbResolveBitmap(filename)
          pbDrawImagePositions(self.bitmap, [[filename, @spriteBaseX + specialX, specialY]])
        end
      end
    end
  end

  alias alpha_dbk_dispose dispose
  def dispose
    if @alphaHpOverlay
      @alphaHpOverlay.dispose
      @alphaHpOverlay = nil
    end
    if @infoHpBitmap
      @infoHpBitmap.dispose
      @infoHpBitmap = nil
    end
    alpha_dbk_dispose
  end

  alias alpha_dbk_visible= visible=
  def visible=(val)
    self.alpha_dbk_visible = val
    if @alphaHpOverlay
      @alphaHpOverlay.visible = val
      @alphaHpOverlay.visible = false if !@battler&.isAlphaBoss?
      @hpBar.visible = !@alphaHpOverlay.visible if @battler && @battler.isAlphaBoss?
    end
  end
end

#===============================================================================
# System 4: Animated Sprite Overlay
#===============================================================================
# DBK's Sprite modification for pattern overlay mapping
class Sprite
  attr_accessor :alpha_pattern_type

  def apply_alpha_pattern(pokemon)
    path = Settings::DELUXE_GRAPHICS_PATH
    return if !pbResolveBitmap(path + "alpha_pattern")
    # Apply pattern if the pokemon has the :RAIDBOSS immunity
    if pokemon && pokemon.respond_to?(:immunities) && pokemon.immunities.include?(:RAIDBOSS)
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
    if pokemon && pokemon.respond_to?(:immunities) && pokemon.immunities.include?(:RAIDBOSS)
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
      self.pattern_scroll_x += 1
      self.pattern_scroll_y -= 1
    end
  end
end

class Battle::Scene::BattlerSprite < RPG::Sprite
  alias alpha_setPokemonBitmap setPokemonBitmap
  def setPokemonBitmap(pokemon, back = false)
    alpha_setPokemonBitmap(pokemon, back)
    self.set_alpha_pattern(pokemon)
  end

  alias alpha_setPokemonBitmapSpecies setPokemonBitmapSpecies
  def setPokemonBitmapSpecies(pokemon, species, back = false)
    alpha_setPokemonBitmapSpecies(pokemon, species, back)
    self.set_alpha_pattern(pokemon)
  end

  alias alpha_update update
  def update
    alpha_update
    return if !@_iconBitmap
    self.update_alpha_pattern
  end
end
