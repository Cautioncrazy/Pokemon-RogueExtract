#==============================================================================
# ** Parche para Visible Overworld Wild Encounters **
# ** Patch for Visible Overworld Wild Encounters **
#==============================================================================
if PluginManager.installed?("Visible Overworld Wild Encounters")
  class Game_Map

    alias_method :zbox_factory_spawnPokeEvent, :spawnPokeEvent
    def spawnPokeEvent(x, y, pokemon)
      zbox_factory_spawnPokeEvent(x, y, pokemon)

      event_id = @events.keys.max
      event = @events[event_id]
      return unless event && event.is_a?(Game_PokeEvent)

      hue = 0
      if pokemon.respond_to?(:zbox_hue_value) && pokemon.zbox_hue_value
        hue = pokemon.zbox_hue_value
      elsif pokemon.super_shiny?
        hue = pkmn.zbox_get_super_shiny_hue
      end

      rpg_event_data = event.instance_variable_get(:@event)

      if rpg_event_data && rpg_event_data.pages[0]
        rpg_event_data.pages[0].graphic.character_hue = hue
        event.character_hue = hue
      end
    end
  end
end