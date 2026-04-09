class Game_Event < Game_Character
  alias __dynamic_graphic_persistence__refresh refresh unless method_defined?(:__dynamic_graphic_persistence__refresh)
  def refresh
    # Run the original refresh logic
    __dynamic_graphic_persistence__refresh

    # Only attempt to restore the graphic if the event hasn't been defeated (Victory Switch "A" is OFF)
    victory_switch = "A"
    return if $game_self_switches && $game_self_switches[[$game_map.map_id, @id, victory_switch]] == true

    # Check if $PokemonGlobal and dynamic_trainers hash exist
    if $PokemonGlobal && $PokemonGlobal.instance_variable_defined?(:@dynamic_trainers)
      dynamic_trainers = $PokemonGlobal.instance_variable_get(:@dynamic_trainers)

      if dynamic_trainers
        # Look for this specific event's assigned trainer data
        event_key = [$game_map.map_id, @id]
        saved_data = dynamic_trainers[event_key]

        if saved_data && saved_data[:type]
          # Restore the character graphic
          chosen_type = saved_data[:type]
          @character_name = "trainer_#{chosen_type.to_s}"
          @character_hue = 0
        end
      end
    end
  end
end
