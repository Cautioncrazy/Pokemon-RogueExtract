#===============================================================================
# System 2: Data Core Gacha (Pokémon Factory Integration)
#===============================================================================

# Define standard gacha currency
GACHA_CURRENCY = :DATACORE_COMMON

class DataCoreHatch_Scene
  def pbStartScene(pokemon, rarity_symbol)
    @sprites = {}
    @pokemon = pokemon
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    # Create background image
    addBackgroundOrColoredPlane(@sprites, "background", "hatch_bg",
                                Color.new(248, 248, 248), @viewport)

    # Clean the rarity symbol to a string just in case
    rarity_str = rarity_symbol.to_s.gsub(":", "")
    
    # Load custom egg graphic based on rarity
    egg_graphic_path = "Graphics/Pokemon/Eggs/#{rarity_str}"
    if pbResolveBitmap(egg_graphic_path)
      @sprites["pokemon"] = Sprite.new(@viewport)
      @sprites["pokemon"].bitmap = Bitmap.new(pbResolveBitmap(egg_graphic_path))
    else
      # Fallback if custom image doesn't exist (v21 standard egg)
      @sprites["pokemon"] = Sprite.new(@viewport)
      @sprites["pokemon"].bitmap = Bitmap.new("Graphics/Pokemon/Eggs/000")
    end

    @sprites["pokemon"].x = Graphics.width / 2
    @sprites["pokemon"].y = 264 + 56
    @sprites["pokemon"].ox = @sprites["pokemon"].bitmap.width / 2
    @sprites["pokemon"].oy = @sprites["pokemon"].bitmap.height

    # Load egg cracks bitmap
    custom_crack_path = "Graphics/Pokemon/Eggs/#{rarity_str}_cracks"
    if pbResolveBitmap(custom_crack_path)
      @hatchSheet = AnimatedBitmap.new(custom_crack_path)
    else
      # Fallback to v21 standard cracks
      @hatchSheet = AnimatedBitmap.new("Graphics/Pokemon/Eggs/cracks")
    end

    # Create egg cracks sprite
    @sprites["hatch"] = Sprite.new(@viewport)
    @sprites["hatch"].x = @sprites["pokemon"].x
    @sprites["hatch"].y = @sprites["pokemon"].y
    @sprites["hatch"].ox = @sprites["pokemon"].ox
    @sprites["hatch"].oy = @sprites["pokemon"].oy
    @sprites["hatch"].bitmap = @hatchSheet.bitmap
    @sprites["hatch"].src_rect = Rect.new(0, 0, @hatchSheet.width / 5, @hatchSheet.height)
    @sprites["hatch"].visible = false

    # Create flash overlay
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["overlay"].z = 200
    @sprites["overlay"].bitmap.fill_rect(0, 0, Graphics.width, Graphics.height, Color.white)
    @sprites["overlay"].opacity = 0

    # Start up scene
    pbFadeInAndShow(@sprites)
  end

  def pbMain
    pbBGMPlay("Evolution")
    # Egg animation
    updateScene(1.5)
    pbPositionHatchMask(0)
    pbSEPlay("Battle ball shake")
    swingEgg(4)
    updateScene(0.2)
    pbPositionHatchMask(1)
    pbSEPlay("Battle ball shake")
    swingEgg(4)
    updateScene(0.4)
    pbPositionHatchMask(2)
    pbSEPlay("Battle ball shake")
    swingEgg(8, 2)
    updateScene(0.4)
    pbPositionHatchMask(3)
    pbSEPlay("Battle ball shake")
    swingEgg(16, 4)
    updateScene(0.2)
    pbPositionHatchMask(4)
    pbSEPlay("Battle recall")

    # Fade and change the sprite
    timer_start = System.uptime
    loop do
      tone_val = lerp(0, 255, 0.4, timer_start, System.uptime)
      @sprites["pokemon"].tone = Tone.new(tone_val, tone_val, tone_val)
      @sprites["overlay"].opacity = tone_val
      updateScene
      break if tone_val >= 255
    end
    updateScene(0.75)

    # Swap to actual Pokemon sprite
    old_x = @sprites["pokemon"].x
    old_y = 264
    
    @sprites["pokemon"].dispose
    @sprites["pokemon"] = PokemonSprite.new(@viewport)
    @sprites["pokemon"].setOffset(PictureOrigin::BOTTOM)

    @sprites["pokemon"].setPokemonBitmap(@pokemon)
    @sprites["pokemon"].x = old_x
    @sprites["pokemon"].y = old_y

    @sprites["hatch"].visible = false
    timer_start = System.uptime
    loop do
      tone_val = lerp(255, 0, 0.4, timer_start, System.uptime)
      @sprites["pokemon"].tone = Tone.new(tone_val, tone_val, tone_val)
      @sprites["overlay"].opacity = tone_val
      updateScene
      break if tone_val <= 0
    end

    # Finish scene
    @pokemon.play_cry
    updateScene(1.5)
    pbBGMStop
    pbMEPlay("Evolution success")
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { update }
    pbDisposeSpriteHash(@sprites)
    @hatchSheet.dispose
    @viewport.dispose
  end

  def pbPositionHatchMask(index)
    @sprites["hatch"].src_rect.x = index * @sprites["hatch"].src_rect.width
  end

  def swingEgg(speed, swingTimes = 1)
    @sprites["hatch"].visible = true
    amplitude = 8
    duration = 0.05 * amplitude / speed
    targets = []
    swingTimes.times do
      targets.push(@sprites["pokemon"].x + amplitude)
      targets.push(@sprites["pokemon"].x - amplitude)
    end
    targets.push(@sprites["pokemon"].x)
    targets.each_with_index do |target, i|
      timer_start = System.uptime
      start_x = @sprites["pokemon"].x
      loop do
        break if i.even? && @sprites["pokemon"].x >= target
        break if i.odd? && @sprites["pokemon"].x <= target
        @sprites["pokemon"].x = lerp(start_x, target, duration, timer_start, System.uptime)
        @sprites["hatch"].x = @sprites["pokemon"].x
        updateScene
      end
    end
    @sprites["pokemon"].x = targets[targets.length - 1]
    @sprites["hatch"].x   = @sprites["pokemon"].x
  end

  def updateScene(duration = 0.01)
    timer_start = System.uptime
    while System.uptime - timer_start < duration
      Graphics.update
      Input.update
      self.update
    end
  end

  def update
    pbUpdateSpriteHash(@sprites)
  end
end

class DataCoreHatchScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen(pokemon, rarity_symbol)
    @scene.pbStartScene(pokemon, rarity_symbol)
    @scene.pbMain
    @scene.pbEndScene
  end
end

def pbDataCoreHatchAnimation(pokemon, rarity_symbol)
  pbMessage(_INTL("Huh?") + "\1")
  pbFadeOutInWithMusic do
    scene = DataCoreHatch_Scene.new
    screen = DataCoreHatchScreen.new(scene)
    screen.pbStartScreen(pokemon, rarity_symbol)
  end
  return true
end

def pbGachaRoll(currency = GACHA_CURRENCY)
  if !$bag.has?(currency, 1)
    pbMessage(_INTL("You do not have any {1}s to spend.", GameData::Item.get(currency).name))
    return false
  end

  if pbConfirmMessage(_INTL("Spend 1 {1} to synthesize a Data Core Pokémon?", GameData::Item.get(currency).name))

    if defined?(ZBox::PokemonFactory) && !ZBox::PokemonFactory.data.empty?
      valid_keys = ZBox::PokemonFactory.data.keys.reject { |k| k.to_s.downcase.start_with?("boss_") }
      if valid_keys.empty?
        pbMessage(_INTL("No Data Core signatures available. (Gacha Pool empty)"))
        return false
      end
      chosen_key = valid_keys.sample
      chosen_data = ZBox::PokemonFactory.data[chosen_key]
      
      # SAFELY EXTRACT EGG TYPE BEFORE CREATION
      # Checks for symbols, strings, and defaults to COMMON so the animation NEVER bypasses
      egg_type = chosen_data[:egg_type] || chosen_data["egg_type"] || chosen_data[:EGG_TYPE] || chosen_data["EGG_TYPE"] || :COMMON
      
      pkmn = ZBox::PokemonFactory.create(chosen_data)

      # FORCE HATCH ANIMATION
      pbDataCoreHatchAnimation(pkmn, egg_type)
    else
      pbMessage(_INTL("No Data Core signatures available. (Gacha Pool empty)"))
      return false
    end

    $bag.remove(currency, 1)

    pbSEPlay("Pkmn get")
    pbMessage(_INTL("Synthesis Complete!\\nObtained {1}!", pkmn.name))

    box_added = false
    3.times do |i|
      next if i >= $PokemonStorage.maxBoxes
      slot = $PokemonStorage.pbFirstFreePos(i)
      if slot
        idx = $PokemonStorage[i].pokemon.index(nil)
        if idx
          $PokemonStorage[i, idx] = pkmn
          box_added = true
          pbMessage(_INTL("{1} was transferred to Box {2}.", pkmn.name, $PokemonStorage[i].name))
          break
        end
      end
    end

    if !box_added
      pbStorePokemon(pkmn)
    end

    return true
  end

  return false
end