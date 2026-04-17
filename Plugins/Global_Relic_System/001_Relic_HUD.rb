#===============================================================================
# Global Relic System - Battle HUD Overlay
#===============================================================================

class Battle::Scene
  alias relic_hud_initialize initialize unless method_defined?(:relic_hud_initialize)
  alias relic_hud_pbStartBattle pbStartBattle unless method_defined?(:relic_hud_pbStartBattle)
  alias relic_hud_pbUpdate pbUpdate unless method_defined?(:relic_hud_pbUpdate)
  alias relic_hud_pbDisposeSprites pbDisposeSprites unless method_defined?(:relic_hud_pbDisposeSprites)

  RELIC_START_X = 16
  RELIC_START_Y = 166
  RELICS_PER_PAGE = 24
  RELIC_GRID_COLS = 6

  def initialize
    relic_hud_initialize
    @relic_hud_sprites = {}
    @relic_page = 0
    @owned_relics = []
  end

  def pbStartBattle(battle)
    relic_hud_pbStartBattle(battle)
    pbInitRelicData
    pbCreateRelicHUD
  end

  def pbInitRelicData
    relics = []
    if defined?(RoguelikeExtraction)
      relics.concat(RoguelikeExtraction::RELICS_UNCOMMON) if defined?(RoguelikeExtraction::RELICS_UNCOMMON)
      relics.concat(RoguelikeExtraction::RELICS_RARE) if defined?(RoguelikeExtraction::RELICS_RARE)
    end

    @owned_relics = []
    relics.each do |relic|
      qty = $bag.quantity(relic)
      if qty > 0
        @owned_relics.push({ :id => relic, :qty => qty })
      end
    end
    @relic_page = 0
  end

  def pbCreateRelicHUD
    return if @owned_relics.empty?

    icon_width = 24
    icon_height = 24
    padding_x = 42
    padding_y = 6

    text_sprite = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSmallFont(text_sprite.bitmap)
    text_sprite.z = 99999
    text_sprite.visible = false
    @relic_hud_sprites["relic_text_all"] = text_sprite

    all_text_pos = []

    # Calculate max pages
    max_pages = (@owned_relics.length.to_f / RELICS_PER_PAGE).ceil
    max_pages = 1 if max_pages == 0

    @owned_relics.each_with_index do |relic_data, i|
      page = i / RELICS_PER_PAGE
      page_idx = i % RELICS_PER_PAGE
      row = page_idx / RELIC_GRID_COLS
      col = page_idx % RELIC_GRID_COLS

      x_pos = RELIC_START_X + (col * (icon_width + padding_x))
      y_pos = RELIC_START_Y + (row * (icon_height + padding_y))

      relic_id = relic_data[:id]
      qty = relic_data[:qty]

      # Item Icon
      icon_sprite = IconSprite.new(x_pos, y_pos, @viewport)
      icon_sprite.setBitmap("Graphics/Items/#{relic_id.to_s.downcase}")
      icon_sprite.zoom_x = 0.5
      icon_sprite.zoom_y = 0.5
      icon_sprite.z = 99998
      icon_sprite.visible = false
      @relic_hud_sprites["relic_icon_#{i}"] = icon_sprite

      text_x = x_pos + 26
      text_y = y_pos + 6

      # We draw all text, but will handle pagination rendering below
      all_text_pos.push(["x#{qty}", text_x, text_y, 0, Color.new(248, 248, 248), Color.new(40, 40, 40)])
    end

    pbDrawTextPositions(text_sprite.bitmap, all_text_pos)
  end

  def pbDrawRelicHUDText
    # Redraws the text sprite to only show current page texts + page indicator
    text_sprite = @relic_hud_sprites["relic_text_all"]
    return unless text_sprite

    text_sprite.bitmap.clear
    all_text_pos = []

    icon_width = 24
    icon_height = 24
    padding_x = 42
    padding_y = 6

    start_idx = @relic_page * RELICS_PER_PAGE
    end_idx = start_idx + RELICS_PER_PAGE - 1

    @owned_relics.each_with_index do |relic_data, i|
      next if i < start_idx || i > end_idx

      page_idx = i % RELICS_PER_PAGE
      row = page_idx / RELIC_GRID_COLS
      col = page_idx % RELIC_GRID_COLS

      x_pos = RELIC_START_X + (col * (icon_width + padding_x))
      y_pos = RELIC_START_Y + (row * (icon_height + padding_y))

      text_x = x_pos + 26
      text_y = y_pos + 6
      qty = relic_data[:qty]
      all_text_pos.push(["x#{qty}", text_x, text_y, 0, Color.new(248, 248, 248), Color.new(40, 40, 40)])
    end

    max_pages = (@owned_relics.length.to_f / RELICS_PER_PAGE).ceil
    max_pages = 1 if max_pages == 0
    page_text = _INTL("Page: {1}/{2}", @relic_page + 1, max_pages)

    # Page indicator text coordinates - bottom right or top right? Let's put it top right relative to grid
    page_x = Graphics.width - 64
    page_y = RELIC_START_Y - 24
    all_text_pos.push([page_text, page_x, page_y, 2, Color.new(248, 248, 248), Color.new(40, 40, 40)])

    pbDrawTextPositions(text_sprite.bitmap, all_text_pos)
  end

  def pbUpdate(*args)
    relic_hud_pbUpdate(*args)

        # We want to show Relic HUD ONLY if the main EBUI :battler window is active
    # and we are not deep into a nested screen.
    is_info_visible = defined?(@enhancedUIToggle) && @enhancedUIToggle == :battler

    # We also check if we are in a sub-menu of the info window by looking at our custom flag
    # @hide_relics_for_summary which is set when pbOpenBattlerInfo is running.
    if is_info_visible && !@hide_relics_for_summary && @sprites["enhancedUI"] && @sprites["enhancedUI"].visible
      should_show = true
    else
      should_show = false
    end
    if should_show
      # Handle Pagination
      max_pages = (@owned_relics.length.to_f / RELICS_PER_PAGE).ceil
      max_pages = 1 if max_pages == 0

      old_page = @relic_page
      if Input.trigger?(Input::LEFT)
        @relic_page -= 1
        @relic_page = max_pages - 1 if @relic_page < 0
        pbPlayCursorSE
      elsif Input.trigger?(Input::RIGHT)
        @relic_page += 1
        @relic_page = 0 if @relic_page >= max_pages
        pbPlayCursorSE
      end

      if old_page != @relic_page
        pbDrawRelicHUDText
      end
    end

    # Ensure text is drawn at least once if needed
    if should_show && !@relic_hud_sprites["relic_text_all"]&.visible
       pbDrawRelicHUDText
    end

    start_idx = @relic_page * RELICS_PER_PAGE
    end_idx = start_idx + RELICS_PER_PAGE - 1

    @relic_hud_sprites.each do |key, sprite|
      if key.include?("relic_icon_")
        idx = key.split("_").last.to_i
        sprite.visible = should_show && (idx >= start_idx && idx <= end_idx)
      elsif key == "relic_text_all"
        sprite.visible = should_show
      end
      sprite.update if sprite.respond_to?(:update)
    end
  end

  def pbDisposeSprites
    pbDisposeSpriteHash(@relic_hud_sprites)
    relic_hud_pbDisposeSprites
  end
end

# Hook into DBK Enhanced Battle UI via EventHandlers
# This resolves load order issues since the code executes at battle start (after all plugins load)
EventHandlers.add(:on_start_battle, :relic_dbk_hook, proc {
  if Battle::Scene.method_defined?(:pbGetDisplayEffects) && !Battle::Scene.method_defined?(:relic_hud_pbGetDisplayEffects)
    Battle::Scene.class_eval do
      alias relic_hud_pbGetDisplayEffects pbGetDisplayEffects

    if Battle::Scene.method_defined?(:pbOpenBattlerInfo) && !Battle::Scene.method_defined?(:relic_hud_pbOpenBattlerInfo)
      Battle::Scene.class_eval do
        alias relic_hud_pbOpenBattlerInfo pbOpenBattlerInfo

        def pbOpenBattlerInfo(battler, battlers)
          @hide_relics_for_summary = true
          ret = relic_hud_pbOpenBattlerInfo(battler, battlers)
          @hide_relics_for_summary = false
          return ret
        end
      end
    end


      def pbGetDisplayEffects(battler)
        display_effects = relic_hud_pbGetDisplayEffects(battler)

        # Only show these global buffs if they apply to the player's side
        if battler.pbOwnedByPlayer? || !battler.opposes?(0)

          # Muscle Relic
          qty = $bag.quantity(:RELIC_MUSCLE)
          if qty > 0
            desc = _INTL("Boosts the physical Attack of the Pokémon by {1}%.", qty * 5)
            display_effects.push([_INTL("Muscle Relic"), _INTL("x{1}", qty), desc])
          end

          # Lens Relic
          qty = $bag.quantity(:RELIC_LENS)
          if qty > 0
            desc = _INTL("Boosts the Accuracy of the Pokémon's moves by {1}%.", qty * 5)
            display_effects.push([_INTL("Lens Relic"), _INTL("x{1}", qty), desc])
          end

          # Extender Relic
          qty = $bag.quantity(:RELIC_EXTENDER)
          if qty > 0
            desc = _INTL("Extends Weather and Terrain duration by {1} turns.", qty)
            display_effects.push([_INTL("Extender Relic"), _INTL("x{1}", qty), desc])
          end

        end

        return display_effects
      end
    end
  end
})
