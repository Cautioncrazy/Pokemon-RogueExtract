#===============================================================================
#
#===============================================================================
class PokemonPokedexInfo_Scene
  alias_method :zbox_start_scene, :pbStartScene  
  def pbStartScene(dexlist, index, region, page = 1)
    @hue = 0
    zbox_start_scene(dexlist, index, region, page)

    if defined?(Settings::VARIATION_COLOR_WILDPOKEMON) && Settings::VARIATION_COLOR_WILDPOKEMON
      # Se inicializan nuestras nuevas variables de estado.
      # Our new state variables are initialized.
      @sprites["leftarrow"] = AnimatedSprite.new("Graphics/UI/left_arrow", 8, 40, 28, 2, @viewport)
      @sprites["leftarrow"].x = 16
      @sprites["leftarrow"].y = 132
      @sprites["leftarrow"].play
      @sprites["leftarrow"].visible = false
      @sprites["rightarrow"] = AnimatedSprite.new("Graphics/UI/right_arrow", 8, 40, 28, 2, @viewport)
      @sprites["rightarrow"].x = 455
      @sprites["rightarrow"].y = 132
      @sprites["rightarrow"].play
      @sprites["rightarrow"].visible = false
      @sprites["huetext"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
      pbSetSystemFont(@sprites["huetext"].bitmap)
      @sprites["huetext"].visible = false
      @sprites["huepanel"] = IconSprite.new(0, 0, @viewport)
      @sprites["huepanel"].setBitmap("Graphics/Plugins/Pokemon Factory/Pokedex/tone_panel")
      if @sprites["huepanel"].bitmap
        @sprites["huepanel"].ox = @sprites["huepanel"].bitmap.width / 2
        @sprites["huepanel"].oy = @sprites["huepanel"].bitmap.height / 2
      end
      @sprites["huepanel"].x = 256
      @sprites["huepanel"].y = 192 
      @sprites["huepanel"].visible = false
      @sprites["huetext"].z = @sprites["huepanel"].z + 1
    end
  end

  alias_method :zbox_pbUpdateDummyPokemon, :pbUpdateDummyPokemon
  def pbUpdateDummyPokemon
    if !defined?(Settings::VARIATION_COLOR_WILDPOKEMON) || !Settings::VARIATION_COLOR_WILDPOKEMON
      return zbox_pbUpdateDummyPokemon
    end
    
    @species = @dexlist[@index][:species]
    @gender, @form = $player.pokedex.last_form_seen(@species)[0..1]
    @shiny ||= false
    
    metrics_data = GameData::SpeciesMetrics.get_species_form(@species, @form)
    species_id = metrics_data.id
    
    [@sprites["infosprite"], @sprites["formfront"], @sprites["formback"]].compact.each do |sprite|
      is_back_sprite = (sprite == @sprites["formback"])
      
      # Se carga el bitmap base (normal o shiny).
      # The base bitmap (normal or shiny) is loaded.
      sprite.setSpeciesBitmap(@species, @gender, @form, @shiny, false, is_back_sprite)
      
      # Se accede al wrapper interno y se crea una copia.
      # The internal wrapper is accessed and a copy is created.
      internal_wrapper = sprite.instance_variable_get(:@_iconbitmap)
      next if !internal_wrapper
      copied_wrapper = internal_wrapper.copy
      
      # Se aplican las modificaciones de HUE a la copia.
      # The HUE modifications are applied to the copy.
      copied_wrapper.hue_change(@hue) if @hue != 0
      
      # Se reemplaza el wrapper interno y se actualiza el bitmap visible.
      # The internal wrapper is replaced and the visible bitmap is updated.
      sprite.instance_variable_set(:@_iconbitmap, copied_wrapper)
      sprite.bitmap = copied_wrapper.bitmap
    end
    
    if PluginManager.installed?("[DBK] Animated Pokémon System")
      # Se asignan los valores de constricción y se llama a pbSetDisplay.
      # The constraint values ​​are assigned and pbSetDisplay is called.
      @sprites["infosprite"].pbSetDisplay([104, 136, 208, 200], species_id)
      @sprites["formfront"].pbSetDisplay([130, 158, 200, 196], species_id)
      if @sprites["formback"]
        @sprites["formback"].setOffset(PictureOrigin::CENTER)
        @sprites["formback"].pbSetDisplay([382, 158, 200, 196], species_id, true)
        if metrics_data.back_sprite_scale != metrics_data.front_sprite_scale
          zoom = metrics_data.front_sprite_scale.to_f / metrics_data.back_sprite_scale
          @sprites["formback"].zoom_x = zoom
          @sprites["formback"].zoom_y = zoom
        else
          @sprites["formback"].zoom_x = 1.0
          @sprites["formback"].zoom_y = 1.0
        end
      end
    else
      # Se mantiene el comportamiento original de posicionamiento.
      # The original positioning behavior is maintained.
      if @sprites["formback"]
        @sprites["formback"].setOffset(PictureOrigin::BOTTOM)
        @sprites["formback"].y = 256
        @sprites["formback"].y += metrics_data.back_sprite[1] * 2
        @sprites["formback"].zoom_x = 1.0
        @sprites["formback"].zoom_y = 1.0
      end
    end
    
    if @sprites["formicon"]
      icon_sprite = @sprites["formicon"]
      icon_sprite.pbSetParams(@species, @gender, @form, @shiny)
      
      internal_anim_bitmap = icon_sprite.instance_variable_get(:@animBitmap)
      if internal_anim_bitmap
        copied_anim_bitmap = internal_anim_bitmap.copy
        copied_anim_bitmap.hue_change(@hue) if @hue != 0
        icon_sprite.instance_variable_set(:@animBitmap, copied_anim_bitmap)
        icon_sprite.bitmap = copied_anim_bitmap.bitmap
        icon_sprite.src_rect.width  = copied_anim_bitmap.height
        icon_sprite.src_rect.height = copied_anim_bitmap.height       
        icon_sprite.update
      end
    end

    # Se aplica el HUE a los sprites después de que han sido creados.
    # The HUE is applied to sprites after they have been created.
    [@sprites["infosprite"], @sprites["formfront"], @sprites["formback"]].compact.each do |sprite|
      internal_bitmap_wrapper = sprite.instance_variable_get(:@_iconbitmap)
      if internal_bitmap_wrapper
        # Se crea una copia para no modificar la caché.
        # Se crea una copia para no modificar el caché.
        copied_wrapper = internal_bitmap_wrapper.copy
        copied_wrapper.hue_change(@hue) if @hue != 0
        sprite.instance_variable_set(:@_iconbitmap, copied_wrapper)
        sprite.bitmap = copied_wrapper.bitmap
      end
    end
  end

  alias_method :zbox_pokedex_scene, :pbScene
  def pbScene
    if !defined?(Settings::VARIATION_COLOR_WILDPOKEMON) || !Settings::VARIATION_COLOR_WILDPOKEMON
      return zbox_pokedex_scene
    end

    Pokemon.play_cry(@species, @form)
    max_page = pbGetMaxPages
    loop do
      Graphics.update
      Input.update
      pbUpdate
      dorefresh = false
      
      if Input.trigger?(Input::ACTION)
        pbSEStop
        Pokemon.play_cry(@species, @form) if @page == 1
      elsif Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      elsif Input.trigger?(Input::USE)
        case @page
        when 1   
          pbPlayDecisionSE
          @show_battled_count = !@show_battled_count
          dorefresh = true
        when 3   
          pbPlayDecisionSE
          pbChooseFormAndHue
          dorefresh = true
        end
      elsif Input.trigger?(Input::UP)
        oldindex = @index
        pbGoToPrevious
        if @index != oldindex
          @shiny = false; @hue = 0
          pbUpdateDummyPokemon
          @available = pbGetAvailableForms
          pbSEStop
          (@page == 1) ? Pokemon.play_cry(@species, @form) : pbPlayCursorSE
          dorefresh = true
        end
      elsif Input.trigger?(Input::DOWN)
        oldindex = @index
        pbGoToNext
        if @index != oldindex
          @shiny = false; @hue = 0
          pbUpdateDummyPokemon
          @available = pbGetAvailableForms
          pbSEStop
          (@page == 1) ? Pokemon.play_cry(@species, @form) : pbPlayCursorSE
          dorefresh = true
        end
      elsif Input.trigger?(Input::LEFT)
        oldpage = @page
        @page -= 1
        @page = max_page if @page < 1
        if @page != oldpage
          pbPlayCursorSE
          dorefresh = true
        end
      elsif Input.trigger?(Input::RIGHT)
        oldpage = @page
        @page += 1
        @page = 1 if @page > max_page
        if @page != oldpage
          pbPlayCursorSE
          dorefresh = true
        end
      end

      if dorefresh
        @sprites["leftarrow"].visible = false
        @sprites["rightarrow"].visible = false
        pbUpdateDummyPokemon
        drawPage(@page)
      end
    end
    return @index
  end

  # --- Bucle para el Modo de Edición de Forma y HUE ---
  # --- Loop for Shape Editing Mode and Hue ---
  def pbChooseFormAndHue
    original_shiny = @shiny
    original_hue = @hue
    index = 0
    @available.length.times do |i|
      if @available[i][1] == @gender && @available[i][2] == @form
        index = i
        break
      end
    end
    oldindex = -1
    
    @sprites["huetext"].visible = true
    @sprites["huepanel"].visible = true
    
    dorefresh = true
    
    loop do
      if dorefresh
        @sprites["infosprite"].setSpeciesBitmap(@species, @gender, @form, @shiny)
        @sprites["formfront"]&.setSpeciesBitmap(@species, @gender, @form, @shiny)
        @sprites["formback"]&.setSpeciesBitmap(@species, @gender, @form, @shiny, false, true)
        @sprites["formicon"]&.pbSetParams(@species, @gender, @form, @shiny)
        pbUpdateDummyPokemon
        drawPage(@page)
        
        show_form_arrows = @available.length > 1
        @sprites["uparrow"].visible   = show_form_arrows && (index > 0)
        @sprites["downarrow"].visible = show_form_arrows && (index < @available.length - 1)
        
        @sprites["leftarrow"].visible = (@hue > -Settings::VARIATION_COLOR)
        @sprites["rightarrow"].visible = (@hue < Settings::VARIATION_COLOR)
        
        overlay = @sprites["huetext"].bitmap
        overlay.clear
        label_text = _INTL("Tono")
        hue_text = sprintf("%+d", @hue)
        hue_text = sprintf("%+d", @hue)
        base_color = Color.new(88, 88, 80)
        shadow_color = Color.new(168, 184, 184)
        text_positions = [
          [label_text, 256, 168, :center, base_color, shadow_color],
          [hue_text,   256, 196, :center, base_color, shadow_color]
        ]
        pbDrawTextPositions(overlay, text_positions)
        dorefresh = false
      end
      
      Graphics.update
      Input.update
      pbUpdate
      
      if Input.trigger?(Input::UP) && @available.length > 1 
        pbPlayCursorSE
        index = (index + @available.length - 1) % @available.length
      elsif Input.trigger?(Input::DOWN) && @available.length > 1
        pbPlayCursorSE
        index = (index + 1) % @available.length
       elsif Input.repeat?(Input::LEFT) 
        if @hue > -Settings::VARIATION_COLOR
          pbPlayCursorSE if Input.trigger?(Input::LEFT) 
          @hue -= 1
          dorefresh = true
        end
      elsif Input.repeat?(Input::RIGHT) 
        if @hue < Settings::VARIATION_COLOR
          pbPlayCursorSE if Input.trigger?(Input::RIGHT) 
          @hue += 1
          dorefresh = true
        end
      elsif Input.trigger?(Input::SPECIAL) 
        pbPlayDecisionSE
        @shiny = !@shiny
        dorefresh = true
      elsif Input.trigger?(Input::BACK) || Input.trigger?(Input::USE)
        pbPlayCancelSE
        break
      end
      
      if oldindex != index
        $player.pokedex.set_last_form_seen(@species, @available[index][1], @available[index][2])
        dorefresh = true
        oldindex = index
      end
    end
    
    @shiny = original_shiny
    @hue = original_hue

    @sprites["leftarrow"].visible = false
    @sprites["rightarrow"].visible = false
    @sprites["uparrow"].visible   = false
    @sprites["downarrow"].visible = false
    @sprites["huetext"].visible = false
    @sprites["huetext"].bitmap.clear
    @sprites["huepanel"].visible = false
  end

  def pbGetMaxPages
    max_pages = 3
    
    if PluginManager.installed?("[MUI] Pokedex Data Page")
      max_pages += 1 
    end
    
    return max_pages
  end
end


