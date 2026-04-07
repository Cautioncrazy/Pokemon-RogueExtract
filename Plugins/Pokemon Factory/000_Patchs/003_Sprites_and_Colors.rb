#==============================================================================
# ** Parche para Sprites Personalizados **
# ** Custom Sprite Patch **
#==============================================================================
module GameData
  class Species
    class << self
      # --- Parche para Sprites (Front, Back, etc.) ---
      # --- Patch for Sprites (Front, Back, etc.) ---
      alias_method :zbox_sprite_bitmap_from_pokemon, :sprite_bitmap_from_pokemon
      def sprite_bitmap_from_pokemon(pkmn, back = false, species = nil)
        # Comprueba si hay un override y si el Pokémon es válido.
        # Checks if there is an override and if the Pokémon is valid.
        if pkmn&.respond_to?(:zbox_sprite_override) && pkmn.zbox_sprite_override
          custom_species = pkmn.zbox_sprite_override
          is_shadow = pkmn.respond_to?(:shadow?) ? pkmn.shadow? : pkmn.shadow
          args = [custom_species, pkmn.form, pkmn.gender, pkmn.shiny?, is_shadow, back, pkmn.egg?]
          # Verifica si el archivo del sprite personalizado existe.
          # Check if the custom sprite file exists.
          if GameData::Species.sprite_filename(*args)
            return GameData::Species.sprite_bitmap(*args)
          end
        end
        # Si no hay override o el archivo personalizado no existe, llama al método original.
        # If there is no override or the custom file does not exist, call the original method.
        return zbox_sprite_bitmap_from_pokemon(pkmn, back, species)
      end

      # --- Parche para Iconos ---
      # --- Icon Patch ---
      alias_method :zbox_icon_filename_from_pokemon, :icon_filename_from_pokemon
      def icon_filename_from_pokemon(pkmn)
        if pkmn&.respond_to?(:zbox_sprite_override) && pkmn.zbox_sprite_override
          custom_species = pkmn.zbox_sprite_override
          args = [custom_species, pkmn.form, pkmn.gender, pkmn.shiny?]
          filename = GameData::Species.icon_filename(*args)
          return filename if filename
        end
        return zbox_icon_filename_from_pokemon(pkmn)
      end
    end
  end
end

#==============================================================================
# ** Gestor de Caché para Palette Swap **
# ** Cache Manager for Palette Swap **
#==============================================================================

module PaletteSwapCacheManager
  # Inicializa la caché global si no existe.
  # Initialize the global cache if it does not exist.
  $zbox_palette_swap_cache ||= {}

  def self.get(original_path, palette_name, tolerance = 0.1)
    return nil if original_path.nil? || palette_name.nil?

    cache_key = [original_path, palette_name]

    # --- Devuelve el resultado cacheado al instante ---
    # --- Returns the cached result instantly ---
    if $zbox_palette_swap_cache.key?(cache_key)
      cached_value = $zbox_palette_swap_cache[cache_key]

      # Se comprueba si el valor cacheado es un bitmap y si ha sido liberado.
      # Check if the cached value is a bitmap and if it has been stale.
      if cached_value.is_a?(Bitmap) && cached_value.disposed?
        # El bitmap es obsoleto. Se elimina de la caché y se procede como un "Cache Miss".
        # The bitmap is stale. It is removed from the cache and the process continues.
        $zbox_palette_swap_cache.delete(cache_key)
      else
        # El valor es válido (o es `false` para un sprite omitido).
        # The value is valid (or `false` for a skipped sprite).
        return nil if cached_value == false
        return cached_value.copy
      end
    end

    begin
      original_bmp = Bitmap.new(original_path)
    rescue
      return nil
    end

    # Se aplica el paletteswap al bitmap completo.
    # The paletteswap is applied to the entire bitmap.
    original_bmp.paletteswap(palette_name, tolerance)

    # Se guarda el resultado en la caché y se devuelve una copia.
    # The result is saved in the cache and a copy is returned.
    $zbox_palette_swap_cache[cache_key] = original_bmp
    return original_bmp.copy
  end
end

#==============================================================================
# ** Parche para Tono y Cambio de Paleta Personalizado **
# ** Custom Hue and PaletteSwap Patch **
#==============================================================================

class Bitmap
  def copy
    # Crea un nuevo objeto Bitmap vacío del mismo tamaño.
    # Creates a new empty Bitmap object of the same size.
    new_bitmap = Bitmap.new(self.width, self.height)

    # Copia el contenido del bitmap actual al nuevo.
    # Copies the content of the current bitmap to the new one.
    new_bitmap.blt(0, 0, self, self.rect)

    # Devuelve el nuevo bitmap duplicado.
    # Returns the new duplicated bitmap.
    return new_bitmap
  end

  unless method_defined?(:hue_change)
    def hue_change(hue)
      return if disposed? || hue == 0
      hue_shift = hue % 360
      (0...self.height).each do |y|
        (0...self.width).each do |x|
          pixel = self.get_pixel(x, y)
          next if pixel.alpha == 0

          # Convert RGB to HSL
          r, g, b = pixel.red / 255.0, pixel.green / 255.0, pixel.blue / 255.0
          max = [r, g, b].max
          min = [r, g, b].min
          h = s = l = (max + min) / 2.0

          if max == min
            h = s = 0 # Achromatic
          else
            d = max - min
            s = l > 0.5 ? d / (2.0 - max - min) : d / (max + min)
            case max
            when r then h = (g - b) / d + (g < b ? 6.0 : 0.0)
            when g then h = (b - r) / d + 2.0
            when b then h = (r - g) / d + 4.0
            end
            h /= 6.0
          end

          # Apply the HUE change
          h += hue_shift / 360.0
          h -= 1.0 while h >= 1.0
          h += 1.0 while h < 0.0

          # Convert HSL back to RGB
          if s == 0
            r = g = b = l
          else
            q = l < 0.5 ? l * (1.0 + s) : l + s - l * s
            p = 2.0 * l - q
            r = (h + 1.0/3.0).hue_to_rgb(p, q)
            g = h.hue_to_rgb(p, q)
            b = (h - 1.0/3.0).hue_to_rgb(p, q)
          end

          self.set_pixel(x, y, Color.new(r * 255, g * 255, b * 255, pixel.alpha))
        end
      end
    end
  end

  def paletteswap(palette_name, tolerance = 0.1, translation_map = nil)
    return if disposed? || palette_name.nil? || palette_name.empty?

    if translation_map.nil?
      directory = "Graphics/Plugins/Pokemon Factory/Palettes/"
      filename = palette_name
      palette_bmp = RPG::Cache.load_bitmap(directory, filename) rescue return

      exact_map = {}
      palette_colors = []
      palette_bmp.width.times do |x|
        original_color = palette_bmp.get_pixel(x, 0)
        new_color      = palette_bmp.get_pixel(x, 1)
        key = (original_color.red.to_i << 16) | (original_color.green.to_i << 8) | original_color.blue.to_i
        exact_map[key] = new_color
        palette_colors << [original_color, new_color]
      end
      palette_bmp.dispose

      unique_colors = {}
      self.height.times do |y|
        self.width.times do |x|
          pixel = self.get_pixel(x, y)
          next if pixel.alpha == 0
          key = (pixel.red.to_i << 16) | (pixel.green.to_i << 8) | pixel.blue.to_i
          unique_colors[key] = true
        end
      end

      translation_map = {}
      unique_colors.keys.each do |pixel_key|
        if exact_map.key?(pixel_key)
          translation_map[pixel_key] = exact_map[pixel_key]
          next
        end

        pixel_r = (pixel_key >> 16) & 0xFF
        pixel_g = (pixel_key >> 8) & 0xFF
        pixel_b = pixel_key & 0xFF

        found_color = nil
        palette_colors.each do |original_color, new_color|
          target_r, target_g, target_b = original_color.red.to_i, original_color.green.to_i, original_color.blue.to_i
          r_ok = pixel_r.between?(target_r - (target_r * tolerance).floor, target_r + (target_r * tolerance).ceil)
          g_ok = pixel_g.between?(target_g - (target_g * tolerance).floor, target_g + (target_g * tolerance).ceil)
          b_ok = pixel_b.between?(target_b - (target_b * tolerance).floor, target_b + (target_b * tolerance).ceil)
          if r_ok && g_ok && b_ok
            found_color = new_color
            break
          end
        end
        translation_map[pixel_key] = found_color
      end
    end

    self.height.times do |y|
      self.width.times do |x|
        pixel = self.get_pixel(x, y)
        next if pixel.alpha == 0
        key = (pixel.red.to_i << 16) | (pixel.green.to_i << 8) | pixel.blue.to_i
        new_color = translation_map[key]
        self.set_pixel(x, y, new_color) if new_color
      end
    end
  end


  def export(filename)
    require 'zlib'

    File.open(filename, "wb") do |file|
      file.write [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A].pack('C*')
      ihdr = [self.width, self.height, 8, 6, 0, 0, 0].pack('N2C5')
      file.write [ihdr.size].pack('N')
      file.write 'IHDR'
      file.write ihdr
      file.write [Zlib.crc32('IHDR' + ihdr)].pack('N')

      if self.respond_to?(:to_rgba_bytes)
        raw_data = self.to_rgba_bytes
        scanlines = raw_data.unpack("a#{self.width * 4}" * self.height)
      else
        scanlines = []
        self.height.times do |y|
          scanline = ""
          self.width.times do |x|
            c = self.get_pixel(x, y)
            scanline << [c.red, c.green, c.blue, c.alpha].pack('C4')
          end
          scanlines << scanline
        end
      end

      pixel_data = scanlines.map { |line| "\0" + line }.join
      compressed_data = Zlib::Deflate.deflate(pixel_data, Zlib::BEST_COMPRESSION)

      file.write [compressed_data.size].pack('N')
      file.write 'IDAT'
      file.write compressed_data
      file.write [Zlib.crc32('IDAT' + compressed_data)].pack('N')
      file.write [0].pack('N')
      file.write 'IEND'
      file.write [Zlib.crc32('IEND')].pack('N')
    end
  end
end

# Helper for HSL to RGB conversion
class Float
  def hue_to_rgb(p, q)
    t = self
    t += 1.0 if t < 0.0
    t -= 1.0 if t > 1.0
    return p + (q - p) * 6.0 * t if t < 1.0/6.0
    return q if t < 1.0/2.0
    return p + (q - p) * (2.0/3.0 - t) * 6.0 if t < 2.0/3.0
    return p
  end
end


class AnimatedBitmap
  def hue_change(hue)
    if @bitmaps && @bitmaps.is_a?(Array)
      @bitmaps.each { |bmp| bmp.hue_change(hue) }
    elsif self.bitmap && !self.bitmap.disposed?
      self.bitmap.hue_change(hue)
    end
    self.update if self.respond_to?(:update)
  end

  def paletteswap(palette_name)
    if @bitmaps && @bitmaps.is_a?(Array)
      @bitmaps.each { |bmp| bmp.paletteswap(palette_name) }
    elsif self.bitmap && !self.bitmap.disposed?
      self.bitmap.paletteswap(palette_name)
    end
    self.update if self.respond_to?(:update)
  end

  def copy
    new_obj = self.clone
    new_obj.instance_variable_set(:@bitmap, @bitmap.copy)
    return new_obj
  end
end

# --- Método para generar el cambio de HUE en los Super Shiny ---
# --- Method to generate the HUE change in Super Shiny ---
class Pokemon
  def zbox_get_super_shiny_hue
    return 0 unless self.super_shiny?

    if self.instance_variable_defined?(:@zbox_super_shiny_hue)
      return self.instance_variable_get(:@zbox_super_shiny_hue)
    end

    safe_threshold = defined?(Settings::VARIATION_COLOR) ? Settings::VARIATION_COLOR : 30
    base_steps = [15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180]

    valid_hues = base_steps.select { |hue| hue > safe_threshold }
    valid_hues = [180] if valid_hues.empty?

    random_hue = valid_hues.sample
    random_hue *= -1 if rand(2) == 0

    self.instance_variable_set(:@zbox_super_shiny_hue, random_hue)
    return random_hue
  end
end

# --- Parche para Sprites Fuera de Batalla ---
# --- Out of Battle Sprite Patch ---
class PokemonSprite < Sprite
  def setPokemonBitmap(pokemon, back = false)
    @_iconbitmap&.dispose
    @_iconbitmap = nil
    @pkmn = pokemon

    if !pokemon
      self.bitmap = nil
      return
    end

    original_bitmap_wrapper = (pokemon) ? GameData::Species.sprite_bitmap_from_pokemon(pokemon, back) : nil
    @_iconbitmap = original_bitmap_wrapper ? original_bitmap_wrapper.copy : nil

    if @_iconbitmap && pokemon
      hue = 0
      if pokemon.respond_to?(:zbox_hue_value) && pokemon.zbox_hue_value
        hue = pokemon.zbox_hue_value
      elsif pokemon.super_shiny?
        hue = pokemon.zbox_get_super_shiny_hue
      end

      @_iconbitmap.hue_change(hue) if hue != 0

      if pokemon&.respond_to?(:zbox_palette_swap) && pokemon.zbox_palette_swap
        @_iconbitmap.paletteswap(pokemon.zbox_palette_swap)
      end
    end

    self.bitmap = (@_iconbitmap) ? @_iconbitmap.bitmap : nil
    self.color = Color.new(0, 0, 0, 0)

    if self.respond_to?(:make_grey_if_fainted=)
      self.make_grey_if_fainted = pokemon.fainted?
    end

    changeOrigin

    if self.respond_to?(:animated?) && animated?
      @_iconbitmap.setPokemon(@pkmn, back)
      @_iconbitmap.update_pokemon_sprite
      pbSetDisplay
    end
  end

  alias_method :zbox_setPokemonBitmapSpecies, :setPokemonBitmapSpecies

  def setPokemonBitmapSpecies(pokemon, species, back = false)
    zbox_setPokemonBitmapSpecies(pokemon, species, back)

    if @_iconbitmap
      @_iconbitmap = @_iconbitmap.copy
    end

    if @_iconbitmap && pokemon
      hue = 0
      if pokemon.respond_to?(:zbox_hue_value) && pokemon.zbox_hue_value
        hue = pokemon.zbox_hue_value
      elsif pokemon.super_shiny?
        hue = pokemon.zbox_get_super_shiny_hue
      end
      @_iconbitmap.hue_change(hue) if hue != 0

      if pokemon.respond_to?(:zbox_palette_swap) && pokemon.zbox_palette_swap
        @_iconbitmap.paletteswap(pokemon.zbox_palette_swap)
      end

      self.bitmap = @_iconbitmap.bitmap
    end
  end
end

# --- Parche para Iconos ---
# --- Icon Patch ---
class PokemonIconSprite < Sprite
  alias_method :zbox_pokemon_setter, :pokemon=

  def pokemon=(value)
    @pokemon = value
    @animBitmap&.dispose
    @animBitmap = nil
    if !@pokemon
      self.bitmap = nil
      @current_frame = 0
      return
    end

    hue = 0
    if @pokemon.respond_to?(:zbox_hue_value) && @pokemon.zbox_hue_value
      hue = @pokemon.zbox_hue_value
    elsif @pokemon.super_shiny?
      hue = @pokemon.zbox_get_super_shiny_hue
    end

    filename = GameData::Species.icon_filename_from_pokemon(value)

    @animBitmap = AnimatedBitmap.new(filename, hue)

    if @pokemon.respond_to?(:zbox_palette_swap) && @pokemon.zbox_palette_swap
      @animBitmap = @animBitmap.copy
      @animBitmap.paletteswap(@pokemon.zbox_palette_swap)
    end

    self.bitmap = @animBitmap.bitmap
    self.src_rect.width  = @animBitmap.height
    self.src_rect.height = @animBitmap.height
    self.set_plugin_icon_pattern if self.respond_to?(:set_plugin_icon_pattern)
    @frames_count = @animBitmap.width / @animBitmap.height
    @current_frame = 0 if @current_frame >= @frames_count
    if self.respond_to?(:make_grey_if_fainted=)
      self.make_grey_if_fainted = pokemon.fainted?
    end

    changeOrigin
  end
end

class PokemonBoxIcon < IconSprite
  def refresh
    return if !@pokemon
    pkmn_for_filename = @pokemon
    if @pokemon.respond_to?(:zbox_sprite_override) && @pokemon.zbox_sprite_override
      temp_pkmn = @pokemon.clone
      temp_pkmn.define_singleton_method(:species) { @pokemon.zbox_sprite_override }
      pkmn_for_filename = temp_pkmn
    end

    filename = GameData::Species.icon_filename_from_pokemon(pkmn_for_filename)

    hue = 0
    if @pokemon.respond_to?(:zbox_hue_value) && @pokemon.zbox_hue_value
      hue = @pokemon.zbox_hue_value
    elsif @pokemon.super_shiny?
      hue = @pokemon.zbox_get_super_shiny_hue
    end

    animBitmap = AnimatedBitmap.new(filename, hue)

    if @pokemon.respond_to?(:zbox_palette_swap) && @pokemon.zbox_palette_swap
      animBitmap = animBitmap.copy
      animBitmap.paletteswap(@pokemon.zbox_palette_swap)
    end

    if self.respond_to?(:make_grey_if_fainted=)
      self.make_grey_if_fainted = @pokemon.fainted?
    end

    self.bitmap = animBitmap.bitmap
    self.src_rect = Rect.new(0, 0, self.bitmap.height, self.bitmap.height)

    @animBitmap = animBitmap if self.instance_variable_defined?(:@animBitmap)
  end
end

# --- Parche para Sprites de Batalla ---
# --- Battle Sprite Patch ---
class Battle::Scene::BattlerSprite < RPG::Sprite

  alias_method :zbox_setpokemonbitmap, :setPokemonBitmap
  def setPokemonBitmap(pkmn, back = false)
    zbox_setpokemonbitmap(pkmn, back)

    return if !@_iconBitmap || @_iconBitmap.disposed?

    needs_hue = (pkmn.respond_to?(:zbox_hue_value) && pkmn.zbox_hue_value) || pkmn.super_shiny?
    needs_palette = (pkmn.respond_to?(:zbox_palette_swap) && pkmn.zbox_palette_swap)

    return unless needs_hue || needs_palette

    if @_iconBitmap.respond_to?(:copy)
      @_iconBitmap = @_iconBitmap.copy
    else
      @_iconBitmap = @_iconBitmap.clone
    end

    hue = 0
    if pkmn.respond_to?(:zbox_hue_value) && pkmn.zbox_hue_value
      hue = pkmn.zbox_hue_value
    elsif pkmn.super_shiny?
      hue = pkmn.zbox_get_super_shiny_hue
    end

    @_iconBitmap.hue_change(hue) if hue != 0

    if pkmn.respond_to?(:zbox_palette_swap) && pkmn.zbox_palette_swap
      @_iconBitmap.paletteswap(pkmn.zbox_palette_swap)
    end

    self.bitmap = @_iconBitmap.bitmap
  end
end