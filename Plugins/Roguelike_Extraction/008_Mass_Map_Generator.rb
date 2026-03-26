#===============================================================================
# Mass Map Generator for Roguelike Extraction
#===============================================================================
# Adds a debug command to mass-generate blank RPG::Map (.rxdata) files
# and link them into the MapInfos.rxdata registry so they appear in the editor.
#===============================================================================

def pbMassGenerateRoguelikeMaps
  start_id = pbMessageChooseNumber("Enter Start Map ID:", 999)
  return if start_id <= 0

  end_id = pbMessageChooseNumber("Enter End Map ID:", 999)
  return if end_id < start_id

  if pbConfirmMessage("This will generate blank maps from #{start_id} to #{end_id}. The editor must be closed. Continue?")
    mapinfos_path = "Data/MapInfos.rxdata"

    # Load the existing MapInfos registry
    begin
      mapinfos = File.open(mapinfos_path, "rb") { |f| Marshal.load(f) }
    rescue
      pbMessage("Failed to load Data/MapInfos.rxdata. Aborting.")
      return
    end

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

      # Create a new blank RPG::Map
      map = RPG::Map.new(width, height)

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

    pbMessage("Successfully generated #{count} new maps. Please completely restart RPG Maker XP to see them in the map tree.")
  end
end

# Register the command in the standard Pokémon Essentials v21.1 Debug Menu
MenuHandlers.add(:debug_menu, :mass_map_generator, {
  "name"        => _INTL("Mass Generate RL Maps"),
  "parent"      => :other_menu,
  "description" => _INTL("Creates a range of blank .rxdata maps for procedural dungeons."),
  "effect"      => proc { |menu|
    pbMassGenerateRoguelikeMaps
  }
})
