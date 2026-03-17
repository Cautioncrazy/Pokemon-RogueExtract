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

  # Mobile Optimized Valid Tile Finder
  # Randomly samples coordinates instead of iterating the entire map array.
  # This prevents heavy O(W*H) loops that drain mobile CPUs (JoiPlay).
  def self.find_random_valid_tile(max_attempts = 100)
    return [0, 0] if !$game_map || !$game_map.valid?(0, 0)

    width = $game_map.width
    height = $game_map.height

    max_attempts.times do
      x = rand(width)
      y = rand(height)

      # 1. Check if the tile is within the map boundaries and not the void
      next if !$game_map.valid?(x, y)

      # 2. Check Passability (can the player actually walk here?)
      # Ruby 3.1 crashes on negative bit shifts if d = 0, so we check standard movement directions.
      # If the player can move onto the tile from at least one adjacent direction, it's walkable.
      passable_directions = [2, 4, 6, 8]
      is_passable = passable_directions.any? { |d| $game_player.passable?(x, y, d) }
      next if !is_passable

      # 3. Check Terrain Tag
      terrain_tag = $game_map.terrain_tag(x, y)
      next if !VALID_FLOOR_TERRAIN_TAGS.include?(terrain_tag.id)

      # 4. Check if another event is already here
      event_present = $game_map.events.values.any? { |e| e.x == x && e.y == y }
      next if event_present

      # Tile is valid!
      return [x, y]
    end

    # Fallback to (0,0) or a known safe spot if we fail max_attempts
    # This ensures the game doesn't hang in an infinite loop on tiny/broken maps
    return [0, 0]
  end

  # The Spawner Function
  def self.spawn_dynamic_events
    return if !$game_map || !$game_map.events

    # Iterate through all events on the newly generated map
    $game_map.events.values.each do |event|
      # We identify dynamic entities by their Event Name in RPG Maker
      name = event.name.downcase

      if name.include?("vip") || name.include?("trainer") || name.include?("chest")
        # Find a valid coordinate for this specific event
        valid_coords = find_random_valid_tile(150)

        # Teleport the event to the valid tile
        event.moveto(valid_coords[0], valid_coords[1])

        # Ensure the event's sprite/graphic updates to the new location immediately
        event.refresh if event.respond_to?(:refresh)
      end
    end
  end
end

#===============================================================================
# Hooking into Map Generation
#===============================================================================
# We hook into the end of the map setup process. In Essentials, maps are setup
# via Game_Map#setup. The Overworld_RandomDungeons module modifies this process.
# By hooking after the setup finishes, we ensure the dungeon has been generated.

EventHandlers.add(:on_enter_map, :dynamic_dungeon_spawner,
  proc { |_old_map_id|
    # Only run the spawner if the current map is flagged as a Dungeon in map_metadata.txt
    if GameData::MapMetadata.exists?($game_map.map_id)
      metadata = GameData::MapMetadata.get($game_map.map_id)
      if metadata.has_flag?("Dungeon")
        RoguelikeExtraction.spawn_dynamic_events
      end
    end
  }
)
