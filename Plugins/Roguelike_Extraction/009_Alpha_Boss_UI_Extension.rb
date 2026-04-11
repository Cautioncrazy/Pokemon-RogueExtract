#===============================================================================
# System 1: Alpha Boss Battles (DBK UI Extension)
#===============================================================================

# Define Alpha Boss check
class Battle::Battler
  def isAlphaBoss?
    return isRaidBoss?
  end
end

class Battle::Scene::PokemonDataBox < Sprite

  # Dynamic HP bar tiers cycle from red -> orange -> purple
  ALPHA_HP_TIERS = [
    Color.new(255, 0, 0),     # 0: Red
    Color.new(255, 128, 0),   # 1: Orange
    Color.new(160, 32, 240)   # 2: Purple
  ]

  alias alpha_dbk_refresh_hp refresh_hp
  def refresh_hp
    alpha_dbk_refresh_hp

    return if !@battler || !@battler.pokemon || !@battler.isAlphaBoss?

    # Generate colored rect overlays on top of the HP Bar.
    unless @alphaHpOverlay
      @alphaHpOverlay = Sprite.new(@viewport)
      @alphaHpOverlay.z = @hpBar.z + 1
      @alphaHpOverlay.bitmap = Bitmap.new(@hpBarBitmap.width, @hpBarBitmap.height / 3)
    end

    # Enforce tiers for Alpha Bosses using DBK's hp_boost
    tier_count = (@battler.pokemon.respond_to?(:hp_boost) ? @battler.pokemon.hp_boost : (@battler.pokemon.respond_to?(:hp_level) ? [@battler.pokemon.hp_level, 1].max : 1))
    tier_count = 1 if tier_count < 1

    pct = self.hp.to_f / @battler.totalhp.to_f
    current_tier = (pct * tier_count).ceil
    current_tier = 1 if current_tier < 1

    # Calculate the percentage within the current tier
    tier_pct = (pct * tier_count) - (current_tier - 1)

    w = @hpBarBitmap.width.to_f * tier_pct
    w = 1 if w < 1 && self.hp > 0
    w = ((w / 2.0).round) * 2
    w = @hpBarBitmap.width if w > @hpBarBitmap.width

    bar_color = ALPHA_HP_TIERS[(current_tier - 1) % ALPHA_HP_TIERS.length]

    @alphaHpOverlay.x = @hpBar.x
    @alphaHpOverlay.y = @hpBar.y
    @alphaHpOverlay.bitmap.clear

    # Draw "Under" bar color (the next tier down) if we are above the last tier
    if current_tier > 1
      under_color = ALPHA_HP_TIERS[(current_tier - 2) % ALPHA_HP_TIERS.length]
      @alphaHpOverlay.bitmap.fill_rect(0, 0, @hpBarBitmap.width, @hpBarBitmap.height / 3, under_color)
    end

    # Draw "Active" depleting bar color
    @alphaHpOverlay.bitmap.fill_rect(0, 0, w, @hpBarBitmap.height / 3, bar_color)
    @alphaHpOverlay.visible = true

    # Hide the default HP bar so our overlay takes precedence
    @hpBar.visible = false
  end

  # Clean up our overlay when disposed
  alias alpha_dbk_dispose dispose
  def dispose
    @alphaHpOverlay&.dispose
    alpha_dbk_dispose
  end

  # Fix visibility updates
  alias alpha_dbk_visible= visible=
  def visible=(val)
    self.alpha_dbk_visible = val
    if @alphaHpOverlay
      @alphaHpOverlay.visible = val
      @alphaHpOverlay.visible = false if !@battler&.isAlphaBoss?
      @hpBar.visible = !@alphaHpOverlay.visible if @battler && @battler.isAlphaBoss?
    end
  end

  # Hook into draw_plugin_elements to draw the "A" icon safely
  if method_defined?(:draw_plugin_elements)
    alias alpha_dbk_draw_plugin_elements draw_plugin_elements
  end

  def draw_plugin_elements
    alpha_dbk_draw_plugin_elements if self.respond_to?(:alpha_dbk_draw_plugin_elements)

    if @battler && @battler.isAlphaBoss?
      # Fallback to standard DBK Databox position if available, else hardcode based on standard vanilla width.
      namePos = nil
      if defined?(@displayPos) && @displayPos && @displayPos[:name]
        namePos = @displayPos[:name].clone
      else
        namePos = [@battler.index.even? ? 16 : 14, 12, false]
      end

      # Draw "A" icon next to the Alpha's name (standard font, vibrant red, pitch black shadow)
      textpos = [
        ["A", namePos[0] + self.bitmap.text_size(@battler.name).width + 8, namePos[1], namePos[2], Color.new(255, 0, 0), Color.new(0, 0, 0)]
      ]
      pbDrawTextPositions(self.bitmap, textpos)
    end
  end

  # For vanilla style databoxes (if DBK style isn't being used or active)
  alias alpha_dbk_refresh_name refresh_name
  def refresh_name
    alpha_dbk_refresh_name
    # draw_plugin_elements isn't natively called in vanilla databox refresh,
    # so we call it here if we aren't using a DBK style
    draw_plugin_elements if @battler && @battler.isAlphaBoss? && !defined?(@style)
  end
end

#-------------------------------------------------------------------------------
# Alpha Boss Silhouette Aura
#-------------------------------------------------------------------------------
class Battle::Scene::BattlerSprite < RPG::Sprite
  alias alpha_dbk_update_battler_sprite update
  def update
    alpha_dbk_update_battler_sprite

    if @battler && @battler.isAlphaBoss? && !@battler.fainted?
      unless @alphaAuraSprite
        @alphaAuraSprite = Sprite.new(self.viewport)
        @alphaAuraSprite.z = self.z - 1 # directly behind
        @alphaAuraAuraPhase = 0
      end

      # Copy properties from this sprite
      @alphaAuraSprite.bitmap = self.bitmap
      @alphaAuraSprite.src_rect = self.src_rect
      @alphaAuraSprite.x = self.x
      @alphaAuraSprite.y = self.y
      @alphaAuraSprite.ox = self.ox
      @alphaAuraSprite.oy = self.oy
      # Scale it up slightly so it is visible as a silhouette behind the battler
      @alphaAuraSprite.zoom_x = self.zoom_x + 0.15
      @alphaAuraSprite.zoom_y = self.zoom_y + 0.15
      @alphaAuraSprite.angle = self.angle
      @alphaAuraSprite.mirror = self.mirror

      # Pulsing effect
      @alphaAuraAuraPhase += 1
      @alphaAuraAuraPhase = 0 if @alphaAuraAuraPhase > 60
      alpha = 100 + 50 * Math.sin(@alphaAuraAuraPhase * Math::PI / 30.0)

      @alphaAuraSprite.color = Color.new(255, 0, 0, alpha)
      @alphaAuraSprite.visible = self.visible
    else
      if @alphaAuraSprite
        @alphaAuraSprite.visible = false
      end
    end
  end

  alias alpha_dbk_dispose dispose
  def dispose
    @alphaAuraSprite&.dispose
    alpha_dbk_dispose
  end
end
