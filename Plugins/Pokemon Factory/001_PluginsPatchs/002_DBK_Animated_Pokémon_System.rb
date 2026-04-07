#=============================================================================
# Parche para [DBK] Animated Pokémon System
# Patch for [DBK] Animated Pokémon System
#=============================================================================

if PluginManager.installed?("[DBK] Animated Pokémon System")

  class DeluxeBitmapWrapper
    attr_accessor :zbox_palette_name

    alias_method :zbox_original_dbk_refresh, :refresh
    def refresh(bitmaps = nil)
      unless @zbox_palette_name && @bmp_file.is_a?(String)
        return zbox_original_dbk_refresh(bitmaps)
      end

      # Se obtiene el spritesheet completo, ya procesado con la paleta.
      # The complete spritesheet is obtained, already processed with the palette.
      processed_sheet = PaletteSwapCacheManager.get(@bmp_file, @zbox_palette_name)

      # Si el gestor falla, se recurre al método original.
      # If the handler fails, the original method is used.
      unless processed_sheet && !processed_sheet.disposed?
        return zbox_original_dbk_refresh(bitmaps)
      end

      self.dispose
      @bitmaps = []

      if processed_sheet.width > (processed_sheet.height * 1.5)
        frame_width = processed_sheet.height
        @width = frame_width * @scale
        @height = frame_width * @scale
        num_frames = (processed_sheet.width.to_f / frame_width).ceil

        num_frames.times do |i|
          x = i * frame_width
          frame_bitmap = Bitmap.new(@width, @height)
          rect_src = Rect.new(x, 0, frame_width, frame_width)
          rect_dest = Rect.new(0, 0, @width, @height)
          frame_bitmap.stretch_blt(rect_dest, processed_sheet, rect_src)
          @bitmaps.push(frame_bitmap)
        end
      else
        @width = processed_sheet.width * @scale
        @height = processed_sheet.height * @scale
        frame_bitmap = Bitmap.new(@width, @height)
        rect_src = Rect.new(0, 0, processed_sheet.width, processed_sheet.height)
        rect_dest = Rect.new(0, 0, @width, @height)
        frame_bitmap.stretch_blt(rect_dest, processed_sheet, rect_src)
        @bitmaps.push(frame_bitmap)
      end

      processed_sheet.dispose

      if !self.is_bitmap? && @bitmaps.length > 0
        @total_frames = @bitmaps.length
        @temp_bmp = Bitmap.new(@width, @height)
      end
    end

    def paletteswap(palette_name)
      return if @zbox_palette_name == palette_name
      @zbox_palette_name = palette_name
      self.refresh
    end

    def copy
      new_wrapper = self.clone
      new_bitmaps = @bitmaps.map { |bmp| bmp.copy }
      new_wrapper.instance_variable_set(:@bitmaps, new_bitmaps)

      if @temp_bmp && !@temp_bmp.disposed?
        new_wrapper.instance_variable_set(:@temp_bmp, @temp_bmp.copy)
      end

      return new_wrapper
    end

    alias_method :zbox_factory_dbk_set_pokemon, :setPokemon

    def setPokemon(pokemon, back = false, hue = nil, species = nil)
      @pokemon = pokemon
      return if !@pokemon

      real_pkmn = @pokemon
      if @pokemon.is_a?(Battle::Battler)
        real_pkmn = @pokemon.pokemon
      end

      final_hue = hue
      if real_pkmn && real_pkmn.respond_to?(:zbox_hue_value) && real_pkmn.zbox_hue_value
        final_hue = real_pkmn.zbox_hue_value
      elsif real_pkmn && real_pkmn.super_shiny?
        final_hue = real_pkmn.zbox_get_super_shiny_hue
      end

      case @pokemon
      when Pokemon
        species_val = species || @pokemon.species
        metrics = GameData::SpeciesMetrics.get_species_form(species_val, @pokemon.form, @pokemon.gender == 1)
        if $PokemonSystem.animated_sprites == 0
          @speed = (back) ? metrics.back_sprite_speed : metrics.front_sprite_speed
          @base_speed = @speed
        end
        if @pokemon.fainted?
          @speed = 0
          @base_speed = 0
        end
      when Battle::Battler
        pkmn = @pokemon.visiblePokemon
        metrics = GameData::SpeciesMetrics.get_species_form(pkmn.species, pkmn.form, pkmn.gender == 1)
        if $PokemonSystem.animated_sprites == 0
          @speed = (back) ? metrics.back_sprite_speed : metrics.front_sprite_speed
          @base_speed = @speed
        end
        if pkmn.fainted?
          @speed = 0
          @base_speed = 0
        end
      end

      hue_change(final_hue) if final_hue && final_hue != 0 && !changedHue?
    end
  end

  class PokemonSprite

    alias_method :zbox_dbk_setSummaryBitmap, :setSummaryBitmap
    def setSummaryBitmap(pkmn, back = false)
      if pkmn&.respond_to?(:zbox_sprite_override) && pkmn.zbox_sprite_override
        temp_pkmn = pkmn.clone
        temp_pkmn.define_singleton_method(:species) { pkmn.zbox_sprite_override }
        zbox_dbk_setSummaryBitmap(temp_pkmn, back)
      else
        zbox_dbk_setSummaryBitmap(pkmn, back)
      end

      hue = 0
      if pkmn&.respond_to?(:zbox_hue_value) && pkmn.zbox_hue_value
        hue = pkmn.zbox_hue_value
      elsif pkmn&.super_shiny?
        hue = @pokemon.zbox_get_super_shiny_hue
      end
      @_iconbitmap.hue_change(hue) if @_iconbitmap && hue != 0

      if pkmn&.respond_to?(:zbox_palette_swap) && pkmn.zbox_palette_swap
        @_iconbitmap.paletteswap(pkmn.zbox_palette_swap) if @_iconbitmap
      end

      self.bitmap = @_iconbitmap.bitmap if @_iconbitmap
    end
  end

  class Pokemon
    def super_shiny_hue
      return self.zbox_get_super_shiny_hue
    end
  end

  module GameData
    class SpeciesMetrics
      def sprite_super_hue
        return @super_shiny_hue if @super_shiny_hue && @super_shiny_hue != 0
        return nil
      end
    end
  end

  class Battle::Scene::BattlerSprite
    def setPokemonBitmap(pkmn, battler, back = false)
      @pkmn = pkmn
      @battler = battler
      @_iconBitmap&.dispose

      if @substitute
        @_iconBitmap = GameData::Species.substitute_sprite_bitmap(back)
        self.bitmap = (@_iconBitmap) ? @_iconBitmap.bitmap : nil
        self.pattern = nil
        self.pattern_type = nil
        @shadowVisible = @index.odd? || Settings::SHOW_PLAYER_SIDE_SHADOW_SPRITES
      else
        @_iconBitmap = GameData::Species.sprite_bitmap_from_pokemon(@pkmn, back)
        @_iconBitmap.setPokemon(@battler, back)
        self.bitmap = (@_iconBitmap) ? @_iconBitmap.bitmap : nil
        self.set_plugin_pattern(@battler)
        @shadowVisible = @pkmn.species_data.shows_shadow?(back)

        if @_iconBitmap && !@_iconBitmap.disposed?
          if pkmn&.respond_to?(:zbox_palette_swap) && pkmn.zbox_palette_swap
            @_iconBitmap.paletteswap(pkmn.zbox_palette_swap)
          end
          self.bitmap = @_iconBitmap.bitmap
        end
      end
      pbSetPosition
    end
  end

  module GameData
    class Species
      class << self
        alias_method :zbox_dbk_sprite_bitmap_from_pokemon, :sprite_bitmap_from_pokemon

        def sprite_bitmap_from_pokemon(pkmn, back = false, species = nil)
          if pkmn&.respond_to?(:zbox_sprite_override) && pkmn.zbox_sprite_override
            custom_species_name = pkmn.zbox_sprite_override
            is_egg = pkmn.respond_to?(:egg?) && pkmn.egg?

            # Construir los argumentos para buscar el archivo.
            # Build the arguments to search for the file.
            args = [custom_species_name, pkmn.form, pkmn.gender, pkmn.shiny?, pkmn.shadow, back, is_egg]

            # Verifica si el archivo del sprite personalizado realmente existe.
            # Check if the custom sprite file actually exists.
            if GameData::Species.sprite_filename(*args)
              custom_filename = GameData::Species.sprite_filename(*args)

              real_species = pkmn.species
              real_form = pkmn.form
              real_gender = pkmn.respond_to?(:female?) ? pkmn.female? : (pkmn.gender == 1)
              metrics_data = GameData::SpeciesMetrics.get_species_form(real_species, real_form, real_gender)

              bitmap_wrapper = DeluxeBitmapWrapper.new(custom_filename, metrics_data, back)
              bitmap_wrapper.compile_strip(pkmn, back) if bitmap_wrapper && pkmn.respond_to?(:species) && !is_egg
              return bitmap_wrapper
            end
          end

          # Si no hay override o el archivo personalizado no existe, se llama al método original de [DBK].
          # If there is no override or the custom file does not exist, the original [DBK] method is called.
          return zbox_dbk_sprite_bitmap_from_pokemon(pkmn, back, species)
        end
      end
    end
  end
end
