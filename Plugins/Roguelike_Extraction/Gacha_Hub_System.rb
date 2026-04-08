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

    # Load custom egg graphic based on rarity
    egg_graphic_path = "Graphics/Pokemon/Eggs/#{rarity_symbol}.png"
    if pbResolveBitmap(egg_graphic_path)
      @sprites["pokemon"] = Sprite.new(@viewport)
      @sprites["pokemon"].bitmap = Bitmap.new(egg_graphic_path)
      @sprites["pokemon"].x = Graphics.width / 2
      @sprites["pokemon"].y = 264 + 56
      @sprites["pokemon"].ox = @sprites["pokemon"].bitmap.width / 2
      @sprites["pokemon"].oy = @sprites["pokemon"].bitmap.height
    else
      # Fallback if custom image doesn't exist
      @sprites["pokemon"] = PokemonSprite.new(@viewport)
      @sprites["pokemon"].setOffset(PictureOrigin::BOTTOM)
      @sprites["pokemon"].x = Graphics.width / 2
      @sprites["pokemon"].y = 264 + 56
      @sprites["pokemon"].setSpeciesBitmap(@pokemon.species, @pokemon.gender,
                                           @pokemon.form, @pokemon.shiny?,
                                           false, false, true)
    end

    # Load egg cracks bitmap
    custom_crack_path = "Graphics/Pokemon/Eggs/#{rarity_symbol}_cracks.png"
    if pbResolveBitmap(custom_crack_path)
      @hatchSheet = AnimatedBitmap.new(custom_crack_path)
    else
      crackfilename = GameData::Species.egg_cracks_sprite_filename(@pokemon.species, @pokemon.form)
      @hatchSheet = AnimatedBitmap.new(crackfilename)
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
    @sprites["overlay"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
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
    if @sprites["pokemon"].is_a?(Sprite) && !@sprites["pokemon"].is_a?(PokemonSprite)
      @sprites["pokemon"].dispose
      @sprites["pokemon"] = PokemonSprite.new(@viewport)
      @sprites["pokemon"].setOffset(PictureOrigin::BOTTOM)
    end

    @sprites["pokemon"].setPokemonBitmap(@pokemon)
    @sprites["pokemon"].x = old_x
    @sprites["pokemon"].y = old_y
    @pokemon.species_data.apply_metrics_to_sprite(@sprites["pokemon"], 1)

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
    cry_duration = GameData::Species.cry_length(@pokemon.species, @pokemon.form)
    @pokemon.play_cry
    updateScene(cry_duration + 0.1)
    pbBGMStop
    pbMEPlay("Evolution success")

    # Skipping Pokédex and nickname logic for Data Core hatches
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

    # Create the Pokemon using ZBox Factory from dynamic YOUR_EVENTS.rb data
    if defined?(ZBox::PokemonFactory) && !ZBox::PokemonFactory.data.empty?
      chosen_key = ZBox::PokemonFactory.data.keys.sample
      chosen_data = ZBox::PokemonFactory.data[chosen_key]
      pkmn = ZBox::PokemonFactory.create(chosen_data)

      # Hook custom hatch animation if egg_type exists
      if chosen_data[:egg_type]
        pbDataCoreHatchAnimation(pkmn, chosen_data[:egg_type])
      end
    else
      pbMessage(_INTL("No Data Core signatures available. (Gacha Pool empty)"))
      return false
    end

    $bag.remove(currency, 1)

    # Visual/audio feedback for Gacha
    pbSEPlay("Pkmn get")
    pbMessage(_INTL("Synthesis Complete!\\nObtained {1}!", pkmn.name))

    # Attempt to add to the first 3 boxes in PC Storage
    # Unlocked Starters concept
    box_added = false
    # Check boxes 0, 1, 2 for space
    3.times do |i|
      next if i >= $PokemonStorage.maxBoxes
      # Check if there is a free slot in this box
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

    # If the first 3 boxes are full, fallback to default PC logic
    if !box_added
      pbStorePokemon(pkmn)
    end

    return true
  end

  return false
end