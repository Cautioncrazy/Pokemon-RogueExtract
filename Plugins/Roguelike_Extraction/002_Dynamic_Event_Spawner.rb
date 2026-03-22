#===============================================================================
# Procedural Dungeons: Dynamic Event Spawner - Mobile Optimized for v21.1
#===============================================================================
# Hooks into the Overworld_RandomDungeons generation process to randomly spawn
# VIPs, Trainers, and Loot Chests on valid floor tiles.
#===============================================================================

module RoguelikeExtraction
  # Define the Terrain Tags that represent valid floor tiles.
  # Adjust these IDs to match your specific Tileset configuration.
  # Typically 0 is standard passable ground, 1 is ledge, 2 is grass, etc.
  VALID_FLOOR_TERRAIN_TAGS = [:None, :Grass, :TallGrass, :Sand]

  # The Spawner Function
  # Note: Movement/Teleportation is natively handled by Overworld_RandomDungeons.
  # This function strictly assigns dynamic properties (Trainer Classes) and graphics.
  def self.spawn_dynamic_events
    return if !$game_map || !$game_map.events

    # Iterate through all events on the newly generated map
    $game_map.events.values.each do |event|
      # We identify dynamic entities by their Event Name in RPG Maker
      name = event.name.downcase

      if name.include?("vip") || name.include?("trainer") || name.include?("chest")

        # Pre-calculate Trainer/VIP and apply graphics immediately
        if name.include?("vip") || name.include?("trainer")
          is_vip = name.include?("vip")
          pool = is_vip ? RoguelikeExtraction::DYNAMIC_VIPS : RoguelikeExtraction::DYNAMIC_TRAINERS

          # Filter fought trainers natively inside the spawner
          available = pool.reject { |t| RoguelikeExtraction.fought_trainers.include?(t) }
          available = pool if available.empty?

          chosen_trainer = available.sample

          # Store the mapping for this specific event ID
          $PokemonGlobal.instance_variable_set(:@raid_event_trainers, {}) if !$PokemonGlobal.instance_variable_defined?(:@raid_event_trainers) || $PokemonGlobal.instance_variable_get(:@raid_event_trainers).nil?
          $PokemonGlobal.instance_variable_get(:@raid_event_trainers)[event.id] = chosen_trainer

          # Update the overworld graphic. The user confirmed the graphics
          # are prefixed with trainer_ e.g., 'trainer_YOUNGSTER.png'
          trainer_type = chosen_trainer[0]
          graphic_name = "trainer_#{trainer_type.to_s}"

          # The engine natively calls `event.refresh` repeatedly during map load.
          # If we try to inject a MoveRoute or temporarily change `character_name`,
          # the engine will just read the Editor graphic (e.g. NPC 20) and wipe it.
          # To fix this, we permanently overwrite the event's actual page data in memory.
          rpg_event = event.instance_variable_get(:@event)
          if rpg_event && rpg_event.pages
            rpg_event.pages.each do |page|
              if page.graphic
                page.graphic.character_name = graphic_name
                page.graphic.character_hue = 0
              end
            end
          end
        end

        # Tell the event to immediately re-read its (now modified) page data
        event.refresh if event.respond_to?(:refresh)
      end
    end
  end
end

#===============================================================================
# Hooking into Map Generation
#===============================================================================
# Instead of waiting for on_enter_map (which might trigger too late),
# we alias Game_Map.setup to run our logic immediately after the engine's
# Random Dungeon map generation finishes, guaranteeing our event data is processed
# BEFORE the player enters and the sprites render.
#===============================================================================

class Game_Map
  alias roguelike_extraction_map_setup setup unless method_defined?(:roguelike_extraction_map_setup)

  def setup(map_id)
    # 1. Run the native setup (which triggers Overworld_RandomDungeons)
    roguelike_extraction_map_setup(map_id)

    # 2. Check if this newly generated map is a Dungeon
    if GameData::MapMetadata.exists?(@map_id)
      metadata = GameData::MapMetadata.get(@map_id)
      if metadata.has_flag?("Dungeon")
        RoguelikeExtraction.spawn_dynamic_events
      end
    end
  end
end
