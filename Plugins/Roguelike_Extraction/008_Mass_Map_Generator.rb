#===============================================================================
# Mass Map Generator for Roguelike Extraction
#===============================================================================
# Adds a debug command to mass-generate blank RPG::Map (.rxdata) files
# and link them into the MapInfos.rxdata registry so they appear in the editor.
#===============================================================================

def pbMassGenerateRoguelikeMaps
  params = ChooseNumberParams.new
  params.setMaxDigits(3)
  params.setInitialValue(100)

  start_id = pbMessageChooseNumber("Enter Start Map ID:", params)
  return if start_id <= 0

  params.setInitialValue(start_id + 10)
  end_id = pbMessageChooseNumber("Enter End Map ID:", params)
  return if end_id < start_id

  if pbConfirmMessage("This will generate blank maps from #{start_id} to #{end_id}. The editor must be closed. Continue?")
    mapinfos_path = "Data/MapInfos.rxdata"
    tilesets_path = "Data/Tilesets.rxdata"

    # Load the existing MapInfos and Tilesets registry
    begin
      mapinfos = File.open(mapinfos_path, "rb") { |f| Marshal.load(f) }
      tilesets = File.open(tilesets_path, "rb") { |f| Marshal.load(f) }
    rescue
      pbMessage("Failed to load MapInfos or Tilesets. Aborting.")
      return
    end

    # Find valid Dungeon tilesets
    dungeon_tilesets = []
    tilesets.each_with_index do |ts, id|
      next if ts.nil? || ts.name.nil?
      dungeon_tilesets.push({:id => id, :name => ts.name}) if ts.name.start_with?("Dungeon")
    end

    if dungeon_tilesets.empty?
      pbMessage("No tilesets found starting with 'Dungeon'. Please create or rename one first. Aborting.")
      return
    end

    map_themes = {}
    count = 0

    (start_id..end_id).each do |map_id|
      # Skip if map already exists in registry to prevent accidental overwrite of base maps
      if mapinfos.has_key?(map_id)
        pbMessage("Map #{map_id} already exists in MapInfos. Skipping.")
        next
      end

      # Generate random width (20-40) and height (15-30)
      width = rand(20..40)
      height = rand(15..30)

      # Pick a random dungeon tileset
      chosen_ts = dungeon_tilesets.sample

      # Create a new blank RPG::Map
      map = RPG::Map.new(width, height)
      map.tileset_id = chosen_ts[:id]

      # Parse optional theme from tileset name (e.g., 'Dungeon forest_ICE' -> 'ICE')
      if chosen_ts[:name].include?("_")
        theme_suffix = chosen_ts[:name].split("_").last.strip
        map_themes[map_id.to_s] = theme_suffix if !theme_suffix.empty?
      end

      # Save the physical MapXXX.rxdata file
      filename = sprintf("Data/Map%03d.rxdata", map_id)
      File.open(filename, "wb") { |f| Marshal.dump(map, f) }

      # Create and link the MapInfo registry entry
      # 0 parent_id means it will appear at the root level of the map tree
      mapinfo = RPG::MapInfo.new
      mapinfo.name = sprintf("Procedural Map %03d", map_id)
      mapinfo.parent_id = 0
      mapinfo.order = map_id
      mapinfo.expanded = false
      mapinfo.scroll_x = 0
      mapinfo.scroll_y = 0

      mapinfos[map_id] = mapinfo
      count += 1
    end

    # Save the updated registry back to disk
    File.open(mapinfos_path, "wb") { |f| Marshal.dump(mapinfos, f) }

    # Save the theme bridge JSON file for the Python generator
    bridge_path = "tools/pbs_generator/map_themes.json"
    begin
      File.open(bridge_path, "w") do |f|
        # Simple manual JSON formatting since 'json' gem isn't guaranteed in all environments
        f.write("{\n")
        lines = []
        map_themes.each do |k, v|
          lines.push("  \"#{k}\": \"#{v}\"")
        end
        f.write(lines.join(",\n"))
        f.write("\n}")
      end
    rescue => e
      pbMessage("Warning: Failed to save map_themes.json bridge file for Python. #{e.message}")
    end

    pbMessage("Successfully generated #{count} new maps. Please completely restart RPG Maker XP to see them in the map tree.")
  end
end

# Register the command in the standard Pokémon Essentials v21.1 Debug Menu
MenuHandlers.add(:debug_menu, :mass_map_generator, {
  "name"        => _INTL("Mass Generate RL Maps"),
  "parent"      => :editors_menu,
  "description" => _INTL("Creates a range of blank .rxdata maps for procedural dungeons."),
  "effect"      => proc { |menu|
    pbMassGenerateRoguelikeMaps
  }
})
