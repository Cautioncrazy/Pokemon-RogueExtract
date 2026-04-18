#===============================================================================
# Utility to Clean Procedural Maps from MapInfos.rxdata
#===============================================================================
# Run this via the Debug Menu to safely strip out all procedurally generated
# maps from the MapInfos registry without corrupting the RPG Maker XP editor.
#===============================================================================

def pbCleanProceduralMaps
  mapinfos_path = "Data/MapInfos.rxdata"

  begin
    mapinfos = load_data(mapinfos_path)
  rescue
    pbMessage(_INTL("Failed to load MapInfos.rxdata. File may be missing or corrupt."))
    return
  end

  # Array of substrings to target for deletion. Edit this as needed.
  target_words = ["Procedural Map", "Procedural Rift", "Floor", "Rift", "Chamber"]

  deleted_count = 0

  # Iterate over all map entries.
  # Using delete_if allows us to safely modify the hash while iterating.
  mapinfos.delete_if do |map_id, map_info|
    should_delete = false

    # Method 1: Delete by Name matching
    if map_info && map_info.name
      if target_words.any? { |word| map_info.name.include?(word) }
        should_delete = true
      end
    end

    # Method 2: Delete by ID Range (Optional - Uncomment to use)
    # if map_id > 50 && map_id < 999
    #   should_delete = true
    # end

    if should_delete
      deleted_count += 1

      # Optional: Also attempt to delete the physical map file
      filename = sprintf("Data/Map%03d.rxdata", map_id)
      File.delete(filename) if File.exist?(filename)

      true # Marks for deletion from hash
    else
      false # Keeps in hash
    end
  end

  if deleted_count > 0
    begin
      save_data(mapinfos, mapinfos_path)
      pbMessage(_INTL("Successfully cleaned {1} procedural maps from MapInfos.rxdata.\n\nPlease completely restart RPG Maker XP to see the changes.", deleted_count))
    rescue
      pbMessage(_INTL("Cleaned {1} maps, but failed to save MapInfos.rxdata.", deleted_count))
    end
  else
    pbMessage(_INTL("No procedural maps found matching the criteria. Nothing was deleted."))
  end
end

def pbCleanProceduralMapsByRange
  mapinfos_path = "Data/MapInfos.rxdata"

  begin
    mapinfos = load_data(mapinfos_path)
  rescue
    pbMessage(_INTL("Failed to load MapInfos.rxdata. File may be missing or corrupt."))
    return
  end

  params = ChooseNumberParams.new
  params.setMaxDigits(3)
  params.setInitialValue(1)

  start_id = pbMessageChooseNumber("Enter Start Map ID to delete:", params)
  return if start_id <= 0

  params.setInitialValue(start_id + 10)
  end_id = pbMessageChooseNumber("Enter End Map ID to delete:", params)
  return if end_id < start_id

  if !pbConfirmMessage("This will permanently delete ALL maps from ID #{start_id} to #{end_id}. The editor MUST be closed. Continue?")
    return
  end

  deleted_count = 0

  mapinfos.delete_if do |map_id, map_info|
    if map_id >= start_id && map_id <= end_id
      deleted_count += 1
      filename = sprintf("Data/Map%03d.rxdata", map_id)
      File.delete(filename) if File.exist?(filename)
      true
    else
      false
    end
  end

  if deleted_count > 0
    begin
      save_data(mapinfos, mapinfos_path)
      pbMessage(_INTL("Successfully deleted {1} maps from MapInfos.rxdata.\n\nPlease completely restart RPG Maker XP to see the changes.", deleted_count))
    rescue
      pbMessage(_INTL("Deleted {1} maps, but failed to save MapInfos.rxdata.", deleted_count))
    end
  else
    pbMessage(_INTL("No maps found in that ID range. Nothing was deleted."))
  end
end

# Register the command in the standard Pokémon Essentials v21.1 Debug Menu
MenuHandlers.add(:debug_menu, :clean_procedural_maps, {
  "name"        => _INTL("Clean MapInfos (Auto Scrub)"),
  "parent"      => :editors_menu,
  "description" => _INTL("Safely deletes 'ghost' procedural maps by name from the MapInfos registry."),
  "effect"      => proc { |menu|
    if pbConfirmMessage("This will permanently delete maps containing 'Procedural' or 'Rift' from MapInfos. The editor MUST be closed. Continue?")
      pbCleanProceduralMaps
    end
  }
})

MenuHandlers.add(:debug_menu, :clean_procedural_maps_range, {
  "name"        => _INTL("Clean MapInfos (Manual Range)"),
  "parent"      => :editors_menu,
  "description" => _INTL("Safely deletes maps within a specific ID range from the MapInfos registry."),
  "effect"      => proc { |menu|
    pbCleanProceduralMapsByRange
  }
})
