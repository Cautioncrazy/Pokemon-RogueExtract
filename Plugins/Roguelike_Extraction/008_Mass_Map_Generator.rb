#===============================================================================
# Mass Map Generator for Roguelike Extraction
#===============================================================================
# Adds a debug command to mass-generate blank RPG::Map (.rxdata) files
# and link them into the MapInfos.rxdata registry so they appear in the editor.
#===============================================================================

# Helper to easily build an RPG::Event object with scripts and pages
def pbBuildProceduralEvent(x, y, id, name, graphic_name, trigger, direction_fix, stop_anim, script_str, needs_page2=false, needs_page3=false)
  event = RPG::Event.new(x, y)
  event.id = id
  event.name = name

  # Page 1 Setup
  page1 = RPG::Event::Page.new
  page1.trigger = trigger

  if graphic_name
    page1.graphic.character_name = graphic_name

    # If it's a chest, randomize which of the 16 sprites it uses
    if name.downcase == "chest"
      page1.graphic.direction = [2, 4, 6, 8].sample
      page1.graphic.pattern = [0, 1, 2, 3].sample
    end
  end

  page1.direction_fix = direction_fix
  page1.step_anime = stop_anim

  # Set random movement for Trainers and VIPs
  if name.downcase.include?("trainer") || name.downcase == "vip"
    roll = rand(100)
    if roll < 33
      # Fixed / Look around randomly (Type 0)
      page1.move_type = 0
    elsif roll < 66
      # Random walking (Type 1)
      page1.move_type = 1
      page1.move_frequency = 3
      page1.move_speed = 3
    else
      # Custom Pacing (Type 3)
      page1.move_type = 3
      page1.move_frequency = 3
      page1.move_speed = 3

      # Build Move Route
      route = RPG::MoveRoute.new
      route.repeat = true
      route.skippable = true # Ignore if can't move

      pace_dir = rand(2) == 0 ? 1 : 2 # 1 = Down, 2 = Left
      pace_dist = rand(2..4)

      # EventCommand for movement:
      # 1 = Move Down, 2 = Move Left, 3 = Move Right, 4 = Move Up
      list = []
      if pace_dir == 1
        pace_dist.times { list.push(RPG::MoveCommand.new(1)) } # Down
        pace_dist.times { list.push(RPG::MoveCommand.new(4)) } # Up
      else
        pace_dist.times { list.push(RPG::MoveCommand.new(2)) } # Left
        pace_dist.times { list.push(RPG::MoveCommand.new(3)) } # Right
      end
      list.push(RPG::MoveCommand.new(0)) # End
      route.list = list
      page1.move_route = route
    end
  end

  # Page 1 Commands (The Script call)
  # Event Command 355 is "Script", 655 is "Script Continuation"
  list = []
  lines = script_str.split("\n")
  lines.each_with_index do |line, i|
    code = (i == 0) ? 355 : 655
    list.push(RPG::EventCommand.new(code, 0, [line]))
  end
  list.push(RPG::EventCommand.new(0, 0, [])) # Empty command ends list
  page1.list = list
  event.pages[0] = page1

  # Optional Page 2 (For interactable trainers/bosses or opened chests)
  if needs_page2
    page2 = RPG::Event::Page.new
    page2.condition.self_switch_valid = true
    # Chests use Self Switch A, Trainers use Self Switch D (for interaction phase)
    page2.condition.self_switch_ch = (name.downcase == "chest") ? "A" : "D"
    page2.trigger = 0 # Action Button

    if name.downcase == "chest"
      # For chests, page 2 is blank (no graphic, no commands) so it erases itself
      page2.graphic.character_name = ""
      page2.direction_fix = true
      page2.list = [RPG::EventCommand.new(0, 0, [])]
    else
      page2.graphic.character_name = graphic_name if graphic_name
      page2.direction_fix = direction_fix
      page2.step_anime = stop_anim

      # If it's a trainer/vip, page 2 just repeats the exact same script call to trigger battle
      list2 = []
      lines.each_with_index do |line, i|
        code = (i == 0) ? 355 : 655
        list2.push(RPG::EventCommand.new(code, 0, [line]))
      end
      list2.push(RPG::EventCommand.new(0, 0, []))
      page2.list = list2
    end
    event.pages.push(page2)
  end

  # Optional Page 3 (For defeated trainers/bosses)
  if needs_page3
    page3 = RPG::Event::Page.new
    page3.condition.self_switch_valid = true
    page3.condition.self_switch_ch = "A" # Defeated
    page3.trigger = 0 # Action Button
    page3.graphic.character_name = graphic_name if graphic_name
    page3.direction_fix = direction_fix
    page3.step_anime = stop_anim

    list3 = []
    # If it's a VIP, page 3 has the extract prompt
    if name.downcase == "vip"
      list3.push(RPG::EventCommand.new(355, 0, ["pbDefeatedVIP"]))
    end
    list3.push(RPG::EventCommand.new(0, 0, []))
    page3.list = list3
    event.pages.push(page3)
  end

  return event
end

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

    # Scan for available BGMs
    available_bgms = []
    begin
      Dir.glob("Audio/BGM/bgm*.*").each do |f|
        basename = File.basename(f, ".*")
        available_bgms.push(basename) unless available_bgms.include?(basename)
      end
    rescue
    end

    map_themes = {}
    map_bgms = {}
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

      # Assign Random BGM
      if !available_bgms.empty?
        chosen_bgm = available_bgms.sample
        map.autoplay_bgm = true
        map.bgm = RPG::AudioFile.new(chosen_bgm, 100, 100)
        map_bgms[map_id.to_s] = chosen_bgm
      end

      # Parse optional theme from tileset name (e.g., 'Dungeon forest_ICE' -> 'ICE')
      if chosen_ts[:name].include?("_")
        theme_suffix = chosen_ts[:name].split("_").last.strip
        map_themes[map_id.to_s] = theme_suffix if !theme_suffix.empty?
      end

      # Inject Procedural Events into the map
      current_event_id = 1
      map.events = {}

      # 1 VIP
      map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "VIP", nil, 4, false, false, "pbDynamicTrainer(\"A\")", true, true)
      current_event_id += 1

      # 1 Extract NPC
      map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "extract", "ABRA", 0, false, true, "pbEarlyExtractPrompt", false, false)
      current_event_id += 1

      # 1 Trader NPC
      map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "trader", "Trader", 0, false, false, "pbBlackMarketTrader", false, false)
      current_event_id += 1

      # 20 Trainers
      20.times do
        map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "trainer", nil, 4, false, false, "pbDynamicTrainer(\"A\")", true, true)
        current_event_id += 1
      end

      # 20 Chests
      20.times do
        map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "chest", "Chests", 0, true, false, "pbDynamicChestLoot", true, false)
        current_event_id += 1
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

    # Save the bgm bridge JSON file for the Python generator
    bgm_bridge_path = "tools/pbs_generator/map_bgms.json"
    begin
      File.open(bgm_bridge_path, "w") do |f|
        f.write("{\n")
        lines = []
        map_bgms.each do |k, v|
          lines.push("  \"#{k}\": \"#{v}\"")
        end
        f.write(lines.join(",\n"))
        f.write("\n}")
      end
    rescue => e
      pbMessage("Warning: Failed to save map_bgms.json bridge file for Python. #{e.message}")
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
