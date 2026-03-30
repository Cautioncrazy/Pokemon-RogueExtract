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
    relics = [:RELIC_MUSCLE, :RELIC_LENS, :RELIC_EXTENDER]

    owned_relics = []
    relics.each do |relic|
      qty = $PokemonBag.pbQuantity(relic)
      if qty > 0
        owned_relics.push({ :id => relic, :qty => qty })
      end
    end

    return if owned_relics.empty?

    # Define standard spacing and sizing
    icon_width = 48
    icon_padding = 48
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

      # Item Icon
      icon_sprite = IconSprite.new(x_pos, start_y, @viewport)
      icon_sprite.setBitmap("Graphics/Items/#{relic_id.to_s.downcase}")
      icon_sprite.z = 250
      @relic_hud_sprites["relic_icon_#{i}"] = icon_sprite

      text_x = x_pos + 42
      text_y = start_y + 14

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
