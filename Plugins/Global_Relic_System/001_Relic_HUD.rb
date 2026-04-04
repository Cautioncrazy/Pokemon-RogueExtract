#===============================================================================
# Global Relic System - Battle HUD Overlay
#===============================================================================

class Battle::Scene
  alias relic_hud_initialize initialize unless method_defined?(:relic_hud_initialize)
  alias relic_hud_pbStartBattle pbStartBattle unless method_defined?(:relic_hud_pbStartBattle)
  alias relic_hud_pbUpdate pbUpdate unless method_defined?(:relic_hud_pbUpdate)
  alias relic_hud_pbDisposeSprites pbDisposeSprites unless method_defined?(:relic_hud_pbDisposeSprites)

  def initialize
    relic_hud_initialize
    @relic_hud_sprites = {}
  end

  def pbStartBattle(battle)
    relic_hud_pbStartBattle(battle)
    pbCreateRelicHUD
  end

  def pbCreateRelicHUD
    # Define the list of global relics to check
    relics = []
    if defined?(RoguelikeExtraction)
      relics.concat(RoguelikeExtraction::RELICS_UNCOMMON) if defined?(RoguelikeExtraction::RELICS_UNCOMMON)
      relics.concat(RoguelikeExtraction::RELICS_RARE) if defined?(RoguelikeExtraction::RELICS_RARE)
    end

    owned_relics = []
    relics.each do |relic|
      qty = $bag.quantity(relic)
      if qty > 0
        owned_relics.push({ :id => relic, :qty => qty })
      end
    end

    return if owned_relics.empty?

    # Define standard spacing and sizing
    icon_width = 24
    icon_padding = 24
    total_width = (owned_relics.length * (icon_width + icon_padding)) - icon_padding

    # Calculate starting X to center the HUD at the top of the screen
    start_x = (Graphics.width - total_width) / 2
    start_y = 4

    # One combined Quantity Text wrapper
    text_sprite = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSmallFont(text_sprite.bitmap)
    text_sprite.z = 251
    @relic_hud_sprites["relic_text_all"] = text_sprite

    all_text_pos = []

    owned_relics.each_with_index do |relic_data, i|
      relic_id = relic_data[:id]
      qty = relic_data[:qty]

      x_pos = start_x + (i * (icon_width + icon_padding))

      # Item Icon (Scaled down to 50%)
      icon_sprite = IconSprite.new(x_pos, start_y, @viewport)
      icon_sprite.setBitmap("Graphics/Items/#{relic_id.to_s.downcase}")
      icon_sprite.zoom_x = 0.5
      icon_sprite.zoom_y = 0.5
      icon_sprite.z = 250
      @relic_hud_sprites["relic_icon_#{i}"] = icon_sprite

      # Closer text positioning
      text_x = x_pos + 26
      text_y = start_y + 6

      all_text_pos.push(["x#{qty}", text_x, text_y, 0, Color.new(248, 248, 248), Color.new(40, 40, 40)])
    end

    pbDrawTextPositions(text_sprite.bitmap, all_text_pos)
  end

  def pbUpdate(*args)
    relic_hud_pbUpdate(*args)
    @relic_hud_sprites.each_value do |sprite|
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
