#==============================================================================
# ** Parche para Following Pokemon EX **
# ** Patch for Following Pokemon EX **
#==============================================================================
if PluginManager.installed?("Following Pokemon EX")
  module FollowingPkmn
    $zbox_follower_sprite_cache ||= {}
  
    CACHE_DIRECTORY = "Graphics/Characters/PaletteSwap/"
    
    class << self
      alias_method :zbox_change_sprite, :change_sprite
      
      def change_sprite(pkmn)
        display_species = pkmn.respond_to?(:zbox_sprite_override) && pkmn.zbox_sprite_override ? pkmn.zbox_sprite_override : pkmn.species
        palette = pkmn.respond_to?(:zbox_palette_swap) ? pkmn.zbox_palette_swap : nil
        
        hue = 0
        if pkmn.respond_to?(:zbox_hue_value) && pkmn.zbox_hue_value
          hue = pkmn.zbox_hue_value
        elsif pkmn.super_shiny?
          hue = pkmn.zbox_get_super_shiny_hue
        end

        needs_custom_sprite = !palette.nil?
        final_hue = hue
        fname = ""

        shiny_for_filename = pkmn.shiny?
        swimming = false
        if FollowingPkmn.respond_to?(:should_use_swimming_sprites?)
          swimming = FollowingPkmn.should_use_swimming_sprites?
        end

        base_sprite_path = GameData::Species.ow_sprite_filename(display_species, pkmn.form,
          pkmn.gender, shiny_for_filename, pkmn.shadow, swimming)
        
        if needs_custom_sprite
          begin
            base_filename = File.basename(base_sprite_path, ".*")
            clean_palette_name = palette ? palette.gsub(/\..*$/, "") : "base"
            cache_key = "#{base_filename}_#{clean_palette_name}_h#{hue}"
            relative_path = "PaletteSwap/" + cache_key

            unless pbResolveBitmap("Graphics/Characters/" + relative_path)
              target_dir = "Graphics/Characters/PaletteSwap"
              Dir.mkdir(target_dir) unless File.exists?(target_dir)

              original_bmp = Bitmap.new(base_sprite_path)              
              original_bmp.paletteswap(palette)
              original_bmp.hue_change(hue) if hue != 0
              
              full_path = "Graphics/Characters/" + relative_path + ".png"
              original_bmp.export(full_path)
              original_bmp.dispose
              
              System.reload_cache
            end
            
            fname = relative_path
            final_hue = 0
          rescue
            fname = base_sprite_path
          end
        else
          fname = base_sprite_path
        end
        
        fname.gsub!("Graphics/Characters/", "")
        
        FollowingPkmn.get_event&.character_name = fname
        FollowingPkmn.get_data&.character_name  = fname
        FollowingPkmn.get_event&.character_hue  = final_hue
        FollowingPkmn.get_data&.character_hue   = final_hue
      end
    end
  end
end