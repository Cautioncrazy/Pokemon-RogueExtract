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

  # Adjust event setup depending on if it's a trainer
  is_trainer = name.downcase.include?("trainer")

  # Default to no sight range unless randomized
  # In Pokémon Essentials, appending (X) gives sight range
  final_name = name
  needs_sight = false

  # Set random movement for Trainers and VIPs
  if is_trainer || name.downcase == "vip"
    roll = rand(100)

    # Optional static trainers (No sight, Fixed Action Button interaction later)
    if is_trainer && roll < 20
      page1.move_type = 0
    # Miniboss Chasers (Fast, Approach Player, Long Sight)
    elsif is_trainer && roll >= 20 && roll < 35
      page1.move_type = 2 # Approach
      page1.move_frequency = 4 # Faster
      page1.move_speed = 4
      needs_sight = true
      final_name = "Trainer(6)" # Extended sight range
    # Standard Pacing (Custom Route)
    elsif roll >= 35 && roll < 70
      page1.move_type = 3
      page1.move_frequency = 3
      page1.move_speed = 3
      needs_sight = is_trainer # VIPs stay Action Button, standard trainers get sight
      final_name = "Trainer(4)" if is_trainer

      route = RPG::MoveRoute.new
      route.repeat = true
      route.skippable = true

      pace_dir = rand(2) == 0 ? 1 : 2 # 1 = Down, 2 = Left
      pace_dist = rand(2..4)

      list = []
      if pace_dir == 1
        pace_dist.times { list.push(RPG::MoveCommand.new(1)) }
        pace_dist.times { list.push(RPG::MoveCommand.new(4)) }
      else
        pace_dist.times { list.push(RPG::MoveCommand.new(2)) }
        pace_dist.times { list.push(RPG::MoveCommand.new(3)) }
      end
      list.push(RPG::MoveCommand.new(0))
      route.list = list
      page1.move_route = route
    # Random Walking
    else
      page1.move_type = 1
      page1.move_frequency = 3
      page1.move_speed = 3
      needs_sight = is_trainer
      final_name = "Trainer(4)" if is_trainer
    end
  end

  event.name = final_name

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

    # Chests and VIPs/Static Trainers are Action Button.
    # Trainers with sight ranges trigger via Event Touch (2)
    page2.trigger = needs_sight ? 2 : 0

    if name.downcase == "chest"
      # For chests, page 2 is blank (no graphic, no commands) so it erases itself
      page2.graphic.character_name = ""
      page2.direction_fix = true
      page2.list = [RPG::EventCommand.new(0, 0, [])]
    else
      page2.graphic.character_name = graphic_name if graphic_name
      page2.direction_fix = direction_fix
      page2.step_anime = stop_anim

      # Copy movement settings from Page 1 to Page 2 so trainers continue moving
      # while waiting for player interaction
      page2.move_type = page1.move_type
      page2.move_speed = page1.move_speed
      page2.move_frequency = page1.move_frequency
      page2.move_route = page1.move_route

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

    is_defeated_battler = name.downcase.include?("boss") || name.downcase.include?("trainer")

    if is_defeated_battler
      # Blank graphic so it disappears
      page3.graphic.character_name = ""
    else
      page3.graphic.character_name = graphic_name if graphic_name
    end

    page3.direction_fix = direction_fix
    page3.step_anime = stop_anim

    list3 = []
    if is_defeated_battler
      # Purely an empty loop breaker page, no scripts needed
    else
      # If it's a VIP, page 3 has the extract prompt
      if name.downcase == "vip"
        list3.push(RPG::EventCommand.new(355, 0, ["pbDefeatedVIP"]))
      end
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
    map_encounter_types = {}
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
      else
        # E.g. 'Dungeon cave 2' -> 'cave 2'
        theme_suffix = chosen_ts[:name].sub(/^Dungeon\s*/, "").strip
      end
      map_themes[map_id.to_s] = theme_suffix if !theme_suffix.empty?

      # Determine encounter type based on tileset name
      encounter_type = chosen_ts[:name].downcase.include?("forest") ? "Land" : "Cave"
      map_encounter_types[map_id.to_s] = encounter_type

      # Inject Procedural Events into the map
      current_event_id = 1
      map.events = {}

      # 1 VIP
      map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "VIP", nil, 4, false, false, "RoguelikeExtraction.vip_interaction", true, true)
      current_event_id += 1

      # 1 Boss Pokemon
      map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "boss_pkmn", nil, 2, false, false, "RoguelikeExtraction.boss_pkmn_interaction", true, true)
      current_event_id += 1

      # 1 Extract NPC
      map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "extract", "ABRA", 0, false, true, "RoguelikeExtraction.extract_interaction", false, false)
      current_event_id += 1

      # 1 Trader NPC
      map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "trader", "Trader", 0, false, false, "RoguelikeExtraction.trader_interaction", false, false)
      current_event_id += 1

      # Scaling Standard Trainers
      max_trainers = [1 + (count / 5).floor, 10].min
      actual_trainers = rand(1..max_trainers)

      actual_trainers.times do
        map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "trainer", nil, 4, false, false, "RoguelikeExtraction.trainer_interaction", true, true)
        current_event_id += 1
      end

      # 20 Chests
      20.times do
        map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "chest", "Chests", 0, true, false, "RoguelikeExtraction.chest_interaction", true, false)
        current_event_id += 1
      end

# Rift Trigger Statues (Max 2)
if rand(100) < 30 # 30% chance to have statues on the map
  num_statues = rand(1..2)
  num_statues.times do
    switch_choices = [130, 131, 132] # Red, Green, Blue
    switch_choices.push(133) if rand(100) < 5 # 5% chance for Yellow
    chosen_switch = switch_choices.sample

    # We just run a simple pbSet script on interaction
    script_str = "RoguelikeExtraction.statue_interaction(#{chosen_switch})"
    map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "statue", "Statue", 0, true, false, script_str, false, false)
    current_event_id += 1
  end
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

    # Save the encounter types bridge JSON file for the Python generator
    enc_bridge_path = "tools/pbs_generator/map_encounter_types.json"
    begin
      File.open(enc_bridge_path, "w") do |f|
        f.write("{\n")
        lines = []
        map_encounter_types.each do |k, v|
          lines.push("  \"#{k}\": \"#{v}\"")
        end
        f.write(lines.join(",\n"))
        f.write("\n}")
      end
    rescue => e
      pbMessage("Warning: Failed to save map_encounter_types.json bridge file for Python. #{e.message}")
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

MenuHandlers.add(:debug_menu, :roguelike_refresh_themes, {
  "name"        => _INTL("Refresh Dungeon Themes JSON"),
  "parent"      => :editors_menu,
  "description" => _INTL("Re-exports map_themes.json for all existing Dungeon maps based on their Tileset."),
  "effect"      => proc {
    pbRefreshDungeonThemesJSON
  }
})

def pbRefreshDungeonThemesJSON
  mapinfos_path = "Data/MapInfos.rxdata"
  tilesets_path = "Data/Tilesets.rxdata"

  begin
    mapinfos = File.open(mapinfos_path, "rb") { |f| Marshal.load(f) }
    tilesets = File.open(tilesets_path, "rb") { |f| Marshal.load(f) }
  rescue
    pbMessage("Failed to load MapInfos or Tilesets. Aborting.")
    return
  end

  map_themes = {}
  map_encounter_types = {}

  mapinfos.each do |map_id, map|
    next if map.nil? || map.name.nil?
    # Only process maps that we consider "Dungeons" or match our generated patterns
    # A safe heuristic is checking if the Map's tileset has 'Dungeon' in the name
    ts = tilesets[map.tileset_id]
    next if ts.nil? || ts.name.nil? || !ts.name.start_with?("Dungeon")

    if ts.name.include?("_")
      theme_suffix = ts.name.split("_").last.strip
    else
      theme_suffix = ts.name.sub(/^Dungeon\s*/, "").strip
    end
    map_themes[map_id.to_s] = theme_suffix if !theme_suffix.empty?

    encounter_type = ts.name.downcase.include?("forest") ? "Land" : "Cave"
    map_encounter_types[map_id.to_s] = encounter_type
  end

  if map_themes.empty?
    pbMessage("No Dungeon maps found in the database. Nothing to export.")
    return
  end

  bridge_path = "tools/pbs_generator/map_themes.json"
  begin
    File.open(bridge_path, "w") do |f|
      f.write("{\n")
      lines = map_themes.map { |k, v| "  \"#{k}\": \"#{v}\"" }
      f.write(lines.join(",\n"))
      f.write("\n}")
    end
  rescue => e
    pbMessage("Warning: Failed to save map_themes.json. #{e.message}")
  end

  enc_bridge_path = "tools/pbs_generator/map_encounter_types.json"
  begin
    File.open(enc_bridge_path, "w") do |f|
      f.write("{\n")
      lines = map_encounter_types.map { |k, v| "  \"#{k}\": \"#{v}\"" }
      f.write(lines.join(",\n"))
      f.write("\n}")
    end
  rescue => e
    pbMessage("Warning: Failed to save map_encounter_types.json. #{e.message}")
  end

  pbMessage("Successfully exported themes and encounter types for #{map_themes.length} Dungeon maps.")
end

def pbGenerateSingleRiftMap(map_id)
  mapinfos_path = "Data/MapInfos.rxdata"
  tilesets_path = "Data/Tilesets.rxdata"

  begin
    mapinfos = File.open(mapinfos_path, "rb") { |f| Marshal.load(f) }
    tilesets = File.open(tilesets_path, "rb") { |f| Marshal.load(f) }
  rescue
    return false
  end

  dungeon_tilesets = tilesets.compact.select { |ts| ts.name && ts.name.start_with?("Dungeon") }
  return false if dungeon_tilesets.empty?

  chosen_ts = dungeon_tilesets.sample
  width = rand(20..40)
  height = rand(15..30)
map = RPG::Map.new(width, height)
  map.tileset_id = chosen_ts.id

  # Standard Rift Spawns
  current_event_id = 1
  map.events = {}

  # The Exit Portal (Gated by Bounty)
  exit_script = "RiftChallenges.exit_interaction"
  map.events[current_event_id] = pbBuildProceduralEvent(10, 10, current_event_id, "exit", "ExitGraphic", 0, false, false, exit_script, false, false)
  current_event_id += 1

  # The Final Alpha Boss
  boss_script = "RiftChallenges.boss_interaction(#{current_event_id})"
  map.events[current_event_id] = pbBuildProceduralEvent(10, 8, current_event_id, "boss", "BossGraphic", 2, false, false, boss_script, true, true)

  current_event_id += 1

  actual_trainers = rand(2..5)
  actual_trainers.times do
    trainer_script = "RiftChallenges.trainer_interaction(#{current_event_id})"
    map.events[current_event_id] = pbBuildProceduralEvent(rand(2..18), rand(2..18), current_event_id, "trainer", "TrainerGraphic", 2, false, false, trainer_script, true, true)

    current_event_id += 1
  end

  # Save the Manifest
  # Save the Manifest tied to the Map ID
current_manifests = $PokemonGlobal.instance_variable_get(:@current_rift_manifest) || {}
current_manifests[map_id] = {
  :trainers => actual_trainers + 1, # Standard trainers + the final boss
  :items => 0
}
$PokemonGlobal.instance_variable_set(:@current_rift_manifest, current_manifests)


  filename = sprintf("Data/Map%03d.rxdata", map_id)
  File.open(filename, "wb") { |f| Marshal.dump(map, f) }

  mapinfo = RPG::MapInfo.new
  mapinfo.name = sprintf("Procedural Rift %03d", map_id)
  mapinfo.parent_id = 0
  mapinfo.order = map_id
  mapinfos[map_id] = mapinfo
  File.open(mapinfos_path, "wb") { |f| Marshal.dump(mapinfos, f) }

  # Inject GameData::MapMetadata dynamically at runtime
  GameData::MapMetadata.register({
    :id       => map_id,
    :dungeon  => true
  })
  GameData::MapMetadata.save

  return true
end

def pbGenerateRegularFloor(map_id)
  mapinfos_path = "Data/MapInfos.rxdata"
  tilesets_path = "Data/Tilesets.rxdata"

  begin
    mapinfos = File.open(mapinfos_path, "rb") { |f| Marshal.load(f) }
    tilesets = File.open(tilesets_path, "rb") { |f| Marshal.load(f) }
  rescue
    return false
  end

  dungeon_tilesets = tilesets.compact.select { |ts| ts.name && ts.name.start_with?("Dungeon") }
  return false if dungeon_tilesets.empty?

  chosen_ts = dungeon_tilesets.sample
  width = rand(20..40)
  height = rand(15..30)
  map = RPG::Map.new(width, height)
  map.tileset_id = chosen_ts.id

  # Standard Floor Spawns
  current_event_id = 1
  map.events = {}

  # 1 VIP
  map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "VIP", nil, 4, false, false, "RoguelikeExtraction.vip_interaction", true, true)
  current_event_id += 1

  # 1 Boss Pokemon
  map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "boss_pkmn", nil, 2, false, false, "RoguelikeExtraction.boss_pkmn_interaction", true, true)
  current_event_id += 1

  # 1 Extract NPC
  map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "extract", "ABRA", 0, false, true, "RoguelikeExtraction.extract_interaction", false, false)
  current_event_id += 1

  # 1 Trader NPC
  map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "trader", "Trader", 0, false, false, "RoguelikeExtraction.trader_interaction", false, false)
  current_event_id += 1

  # Scaling Standard Trainers
  floor = $PokemonGlobal.current_raid_floor || 1
  max_trainers = [1 + (floor / 5).floor, 10].min
  actual_trainers = rand(1..max_trainers)

  actual_trainers.times do
    map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "trainer", nil, 4, false, false, "RoguelikeExtraction.trainer_interaction", true, true)
    current_event_id += 1
  end

  # 20 Chests
  20.times do
    map.events[current_event_id] = pbBuildProceduralEvent(0, 0, current_event_id, "chest", "Chests", 0, true, false, "RoguelikeExtraction.chest_interaction", true, false)
    current_event_id += 1
  end

  # Save the physical MapXXX.rxdata file
  filename = sprintf("Data/Map%03d.rxdata", map_id)
  File.open(filename, "wb") { |f| Marshal.dump(map, f) }

  # Create and link the MapInfo registry entry
  mapinfo = RPG::MapInfo.new
  mapinfo.name = sprintf("Procedural Floor %03d", map_id)
  mapinfo.parent_id = 0
  mapinfo.order = map_id
  mapinfos[map_id] = mapinfo
  File.open(mapinfos_path, "wb") { |f| Marshal.dump(mapinfos, f) }

  # Inject GameData::MapMetadata dynamically at runtime
  GameData::MapMetadata.register({
    :id       => map_id,
    :dungeon  => true
  })
  GameData::MapMetadata.save

  return true
end
