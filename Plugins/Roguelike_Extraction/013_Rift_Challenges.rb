#===============================================================================
# Rift Challenges System
# Dynamic High-Risk/High-Reward Encounters
#===============================================================================

module RiftChallenges
  # Switches mapped as required
  SWITCH_RED = 130
  SWITCH_GREEN = 131
  SWITCH_BLUE = 132
  SWITCH_YELLOW = 133
  ALL_SWITCHES = [SWITCH_RED, SWITCH_GREEN, SWITCH_BLUE, SWITCH_YELLOW]

  # Scaling variables mapping
  TRAINER_VAR = 99
  WILD_VAR = 100

class << self
  # Debug helper to instantly spawn a portal in front of the player
  def debug_spawn_portal
    return unless $game_map

    # Forcing a switch to be true just to test
    $game_switches[SWITCH_RED] = true if $game_switches

    # Spawn portal in front of the player
    spawn_x = $game_player.x + ($game_player.direction == 6 ? 1 : $game_player.direction == 4 ? -1 : 0)
    spawn_y = $game_player.y + ($game_player.direction == 2 ? 1 : $game_player.direction == 8 ? -1 : 0)

    check_and_spawn_portal(spawn_x, spawn_y)
  end

    def is_rift_map?
      return false unless $PokemonGlobal
      return $PokemonGlobal.instance_variable_get(:@is_active_rift) || false
    end

    def exit_rift
      $PokemonGlobal.instance_variable_set(:@is_active_rift, false) if $PokemonGlobal

      # Restore original difficulty scaling variables
      saved_trainer = $PokemonGlobal.instance_variable_get(:@saved_trainer_var)
      saved_wild = $PokemonGlobal.instance_variable_get(:@saved_wild_var)

      pbSet(TRAINER_VAR, saved_trainer) if saved_trainer
      pbSet(WILD_VAR, saved_wild) if saved_wild

      # Turn off Rift switches
      ALL_SWITCHES.each { |switch| $game_switches[switch] = false if $game_switches }

      # Progress to the next standard floor
      if defined?(RoguelikeExtraction)
        RoguelikeExtraction.advance_floor
      else
        pbMessage(_INTL("Extraction complete."))
      end
    end

    def exit_interaction(interp)
      if check_rift_bounty_complete
        interp.pbMessage(_INTL("The Rift objective is complete. Extracting..."))
        exit_rift
      else
        interp.pbMessage(_INTL("The dimensional lock holds strong. Complete the objective."))
      end
    end

    def boss_interaction(event_id, interp)
      outcome = start_dynamic_boss_battle
      if outcome
        interp.pbSetSelfSwitch(event_id, "A", true)
      end
    end

    def trainer_interaction(event_id, interp)
      outcome = start_dynamic_trainer_battle
      if outcome == 1
        interp.pbSetSelfSwitch(event_id, "A", true)
      end
    end
  end
end

#===============================================================================
# Rift Environment and Weather Handling
#===============================================================================
module RiftChallenges
WEATHER_TYPES = {
  :Rain => { :weather => :Rain, :types => [:WATER, :ELECTRIC, :BUG], :tint => Tone.new(-30, -30, 20, 30) },
  :Sunny => { :weather => :Sun, :types => [:FIRE, :GRASS, :GROUND], :tint => Tone.new(30, 20, -20, 20) },
  :Hail => { :weather => :Snow, :types => [:ICE, :STEEL, :GHOST], :tint => Tone.new(-10, -10, 30, 10) },
  :Sandstorm => { :weather => :Sandstorm, :types => [:ROCK, :GROUND, :STEEL], :tint => Tone.new(20, 10, -30, 20) },
  :HeavyRain => { :weather => :HeavyRain, :types => [:WATER, :DRAGON, :DARK], :tint => Tone.new(-50, -50, 40, 50) }
}


  class << self
def apply_rift_environment(map_id, interp = nil)

      # Select random weather
      weather_key = WEATHER_TYPES.keys.sample
      data = WEATHER_TYPES[weather_key]

      $game_screen.weather(data[:weather], 9, 0)
      $game_screen.start_tone_change(data[:tint], 0)

      $PokemonGlobal.instance_variable_set(:@rift_weather_types, data[:types])

      if interp
        interp.pbMessage(_INTL("A strange anomalous weather has settled over the Rift..."))
      else
        pbMessage(_INTL("A strange anomalous weather has settled over the Rift..."))
      end
    end

    def get_valid_species_for_weather
      types = $PokemonGlobal.instance_variable_get(:@rift_weather_types) || [:NORMAL]
      pool = []
GameData::Species.each do |species|
  # Only use base forms for the pool to be safe, level scaling will evolve them later if needed
  next if species.form != 0
  if species.types.any? { |t| types.include?(t) }
    pool.push(species.id)
  end
end

      # Default fallback
      pool = [:RATTATA, :PIDGEY, :ZUBAT] if pool.empty?
      return pool
    end
  end
end

#===============================================================================
# Hook into PokemonEncounters to force dynamic encounter pool based on weather
#===============================================================================
class PokemonEncounters
  # Intercept has_encounter_type? so the engine knows dynamic maps *can* spawn Pokémon
  # even though they lack a strict PBS entry.
  alias has_encounter_type_dynamic_rift has_encounter_type?
  def has_encounter_type?(enc_type)
    return true if RiftChallenges.is_rift_map? && enc_type == :Cave # Force cave encounters inside Rifts
    # Return true for standard Land/Cave encounter slots on dynamic procedural floors
    if $PokemonGlobal.instance_variable_defined?(:@dungeon_area) && $PokemonGlobal.dungeon_area != :none
      # Determine if the current theme is implicitly a Cave or Land map
      # (e.g. CAVE defaults to :Cave encounters, FOREST defaults to :Land encounters)
      theme = $PokemonGlobal.dungeon_area.to_s.upcase.to_sym

      # We aggressively check against all core cave encounters (e.g. Cave, CaveNight)
      is_cave_query = enc_type.to_s.upcase.include?("CAVE")
      is_water_query = enc_type.to_s.upcase.include?("WATER")

      if theme.to_s.include?("FOREST")
        return false if is_cave_query
        return true if [:Land, :LandMorning, :LandDay, :LandNight].include?(enc_type)
        return false
      elsif theme == :CAVE || theme.to_s.include?("CAVE")
        return true if is_cave_query
        return false # A Cave map shouldn't trigger Land encounters natively
      else
        # For non-cave maps, explicitly block ANY cave query from returning true
        # Also explicitly block water unless it's a water map (if you have water encounters)
        return false if is_cave_query
        return true if [:Land, :LandMorning, :LandDay, :LandNight].include?(enc_type)

        # If it's not a recognized land type (like BugContest), return false
        # so the engine doesn't misinterpret the map flags.
        return false
      end
    end
    has_encounter_type_dynamic_rift(enc_type)
  end

  # We need to completely override encounter_possible_here? for dynamic maps
  # because the base engine evaluates `has_cave_encounters?` globally for the whole map.
  # If our map is a procedural Land map, we ONLY want encounters on `terrain_tag.land_wild_encounters`.
  alias encounter_possible_here_dynamic_rift encounter_possible_here?
  def encounter_possible_here?
    if (RiftChallenges.is_rift_map? || ($PokemonGlobal.instance_variable_defined?(:@dungeon_area) && $PokemonGlobal.dungeon_area != :none))
      return true if $PokemonGlobal.surfing
      terrain_tag = $game_map.terrain_tag($game_player.x, $game_player.y)
      return false if terrain_tag.ice

      theme = $PokemonGlobal.dungeon_area.to_s.upcase.to_sym

      if theme.to_s.include?("FOREST")
        return true if terrain_tag.land_wild_encounters
        return false
      elsif theme == :CAVE || theme.to_s.include?("CAVE") || RiftChallenges.is_rift_map?
        return true # Caves trigger encounters on any walkable tile
      else
        # Land maps STRICTLY require the tile to be flagged for wild encounters (e.g. Grass)
        return true if terrain_tag.land_wild_encounters
        return false
      end
    end
    encounter_possible_here_dynamic_rift
  end

  # We also need to intercept the step chance check so it knows how likely encounters are
  alias encounter_triggered_dynamic_rift encounter_triggered?
  def encounter_triggered?(enc_type, repel_active = false, triggered_by_step = true)
    if (RiftChallenges.is_rift_map? || ($PokemonGlobal.instance_variable_defined?(:@dungeon_area) && $PokemonGlobal.dungeon_area != :none))
      # Only process steps for the valid encounter types on this map
      return false if !has_encounter_type?(enc_type)

      # Ensure land encounters only trigger on valid terrain.
      # If the generator assigned random tiles, some might not be land_wild_encounters!
      # We check if the player's tile actually supports encounters for non-cave maps.
      # NOTE: In v21.1, encounter_possible_here? checks this BEFORE calling encounter_triggered?
      # However, if encounter_possible_here? passes (because has_cave_encounters? was true),
      # we need to make absolutely sure we don't trigger.
      # Since we fixed has_cave_encounters? returning true on Land maps above,
      # encounter_possible_here? will natively block steps on non-grass tiles.
      if !has_cave_encounters?
        terrain_tag = $game_map.terrain_tag($game_player.x, $game_player.y)
        return false if !terrain_tag.land_wild_encounters && triggered_by_step
      end

      # Respect Repels
      if repel_active && $player.first_pokemon
        # In a real setup, you'd check the generated encounter's level.
        # For simplicity, if repel is active, skip.
        return false if triggered_by_step
      end

      # Extremely reduced step chance to balance out procedural floors!
      # The user requested to drastically fix the encounter rate.
      # Default base engine was 10-15%, we will reduce it significantly.
      @step_count += 1
      return false if @step_count < 5 # Minimum grace period extended to 5 steps

      # 5% base chance per step (drastically reduced from 15%)
      # Plus a slight increment per step so you aren't completely dry forever
      chance = 5 + (@step_count / 10).to_i
      chance = 20 if chance > 20

      if rand(100) < chance
        @step_count = 0 # Reset grace period
        return true
      end

      return false
    end
    encounter_triggered_dynamic_rift(enc_type, repel_active, triggered_by_step)
  end

  alias choose_wild_pokemon_dynamic_rift choose_wild_pokemon
  def choose_wild_pokemon(enc_type, chance_rolls = 1)
    # 1. Handle Rift Specific Encounters
    if RiftChallenges.is_rift_map?
      pool = RiftChallenges.get_valid_species_for_weather
      chosen_species = pool.sample

      level = 10
      level = $player.party.first.level if $player && $player.party && !$player.party.empty?

      return [chosen_species, level]
    end

    # 2. Handle standard Procedural Dungeons on-the-fly without PBS
    if $PokemonGlobal.instance_variable_defined?(:@dungeon_area) && $PokemonGlobal.dungeon_area != :none
      # Fallback to the wild species pool based on the map's theme (stored in dungeon_area)
      theme = $PokemonGlobal.dungeon_area.to_s.upcase.to_sym

      pool = [:ZUBAT, :GEODUDE, :MACHOP, :GOLBAT, :GRAVELER]
      if defined?(ProceduralEncounters) && ProceduralEncounters.respond_to?(:get_wild_pool)
        pool = ProceduralEncounters.get_wild_pool(theme)
      end

      chosen_species = pool.sample
      level = 10
      level = $player.party.first.level if $player && $player.party && !$player.party.empty?

      return [chosen_species, level]
    end

    choose_wild_pokemon_dynamic_rift(enc_type, chance_rolls)
  end
end

#===============================================================================
# Dynamic Trainer Generation based on Rift Environment
#===============================================================================
module RiftChallenges
  class << self
    def generate_dynamic_trainer
# Determine trainer class and name
# Get a random valid trainer type from GameData
trainer_keys = GameData::TrainerType.keys
trainer_class = trainer_keys.sample || :TEAMROCKET_M

      trainer_name = "Rift Walker"

      # Create custom trainer object in memory
      trainer = NPCTrainer.new(trainer_name, trainer_class)

      # Determine party size based on difficulty or randomized
      party_size = rand(2..4)

      pool = get_valid_species_for_weather

      level = 10
      if $player && $player.first_pokemon
        level = $player.first_pokemon.level
      end

      party_size.times do
        species = pool.sample
        pkmn = Pokemon.new(species, level)
        pkmn.calc_stats
        trainer.party.push(pkmn)
      end

      return trainer
    end

def start_dynamic_trainer_battle
  trainer = generate_dynamic_trainer

  setBattleRule("canLose") if defined?(setBattleRule)
outcome = TrainerBattle.start_core(trainer)


  if outcome == 1 || outcome == true # Victory
    pbMessage(_INTL("The Rift energy dissipates slightly..."))

    # Decrement Bounty Tracker
    objective = $PokemonGlobal.instance_variable_get(:@current_rift_bounty)
    if objective && objective[:type] == :trainers
      objective[:amount] -= 1
      objective[:amount] = 0 if objective[:amount] < 0
      pbMessage(_INTL("Rift Objective: {1} left.", objective[:amount])) if objective[:amount] > 0
    end

  else
    pbMessage(_INTL("You have succumbed to the Rift."))
  end

  return outcome
end

  end
end

#===============================================================================
# Procedural Boss Factory (In-Engine)
#===============================================================================
module RiftChallenges
  class << self
    def generate_dynamic_boss
      pool = get_valid_species_for_weather
      boss_species = pool.sample

      level = 10
      if $player && $player.first_pokemon
        level = $player.first_pokemon.level + 2 # Slightly higher than party level
      end

      species_data = GameData::Species.get(boss_species)
      moves = species_data.moves.map { |m| m[1] }.uniq.last(4) # Get latest 4 moves natively learned
      moves = [:TACKLE] if moves.empty?

      # Build Boss Hash mimicking Pokemon Factory
      boss_key = "rift_boss_#{boss_species}"
      boss_hash = {
        :species => boss_species,
        :level => level,
        :moves => moves,
        :boss => true,
        :hp_boost => 3 # Alpha UI tier 3
      }

# Register the procedural hash in Pokemon Factory data
if defined?(ZBox::PokemonFactory)
  ZBox::PokemonFactory.data[boss_key.to_sym] = boss_hash
  return boss_key
elsif defined?(PokemonFactory)
  PokemonFactory.data[boss_key.to_sym] = boss_hash
  return boss_key
else
  # Fallback
  return nil
end

    end

def start_dynamic_boss_battle
  boss_key = generate_dynamic_boss
  if boss_key && defined?(pbFightFactoryBoss)
    outcome = pbFightFactoryBoss(boss_key)

    if outcome
      # Decrement Bounty Tracker
      objective = $PokemonGlobal.instance_variable_get(:@current_rift_bounty)
      if objective && objective[:type] == :trainers
        objective[:amount] -= 1
        objective[:amount] = 0 if objective[:amount] < 0
        pbMessage(_INTL("Rift Objective: {1} left.", objective[:amount])) if objective[:amount] > 0
      end
    end
    return outcome
  else
    pbMessage(_INTL("Failed to construct Rift Boss anomaly..."))
    return false
  end
end

  end
end

#===============================================================================
# Rift Bounty System Hook
#===============================================================================
module RiftChallenges
  class << self
    def generate_rift_bounty(map_id, interp = nil)
      manifests = $PokemonGlobal.instance_variable_get(:@current_rift_manifest)
      return unless manifests
      manifest = manifests[map_id]
      return unless manifest

      possible_objectives = []

      if manifest[:trainers] && manifest[:trainers] > 0
        possible_objectives.push({
          :type => :trainers,
          :amount => rand(1..manifest[:trainers]),
          :desc => "Defeat trainers"
        })
      end

      if manifest[:items] && manifest[:items] > 0
        possible_objectives.push({
          :type => :items,
          :amount => rand(1..manifest[:items]),
          :desc => "Collect items"
        })
      end

      if possible_objectives.empty?
        possible_objectives.push({
          :type => :survive,
          :amount => 1,
          :desc => "Survive the Rift"
        })
      end

      objective = possible_objectives.sample
      $PokemonGlobal.instance_variable_set(:@current_rift_bounty, objective)

if defined?(QuestModule) && defined?(activateQuest)
  # We dynamically inject a quest into the QuestModule hash
  QuestModule.const_set(:Quest999, {
    :ID => "999",
    :Name => "Rift Challenge",
    :QuestGiver => "The Rift",
    :Stage1 => "Complete the objective to unlock the exit.",
    :QuestDescription => "Objective: #{objective[:desc]} (#{objective[:amount]})",
    :RewardString => "Survival"
  })
  activateQuest(:Quest999) unless $PokemonGlobal.quests.active_quests.any? { |q| q.id == :Quest999 }
end

      if interp
        interp.pbMessage(_INTL("Rift Objective: {1} ({2}).", objective[:desc], objective[:amount]))
      else
        pbMessage(_INTL("Rift Objective: {1} ({2}).", objective[:desc], objective[:amount]))
      end
    end

    def check_rift_bounty_complete
      objective = $PokemonGlobal.instance_variable_get(:@current_rift_bounty)
      return true unless objective

      if objective[:amount] <= 0
        completeQuest(:Quest999) if defined?(completeQuest)
        return true
      end
      return false
    end

    def transfer_to_rift(target_map_id)
      $game_temp.player_transferring = true
      $game_temp.player_new_map_id = target_map_id
      $game_temp.player_new_x = 10
      $game_temp.player_new_y = 10
      $game_temp.player_new_direction = 2
    end

    def enter_and_transfer_rift(target_map_id, interp)
      enter_rift(target_map_id, interp)
      transfer_to_rift(target_map_id)
    end

    def enter_rift(target_map_id, interp)
      $PokemonGlobal.instance_variable_set(:@is_active_rift, true) if $PokemonGlobal

      # Save scaling variables
      $PokemonGlobal.instance_variable_set(:@saved_trainer_var, pbGet(TRAINER_VAR))
      $PokemonGlobal.instance_variable_set(:@saved_wild_var, pbGet(WILD_VAR))

      # Increment scaling variables by +1 for the duration of the Rift
      interp.pbSet(TRAINER_VAR, pbGet(TRAINER_VAR) + 1)
      interp.pbSet(WILD_VAR, pbGet(WILD_VAR) + 1)

      # We must simulate passing the correct ID so the environment and bounty read the NEW map ID, not the old boss map.
      apply_rift_environment(target_map_id, interp)
      generate_rift_bounty(target_map_id, interp)
    end
  end
end

#===============================================================================
# Rift Portal Spawning Logic
#===============================================================================
module RiftChallenges
  class << self
    def check_and_spawn_portal(boss_x, boss_y)
      # Check if any Rift switch is active
      active_switches = ALL_SWITCHES.select { |s| $game_switches && $game_switches[s] == true }
      return if active_switches.empty?

      # Spawn up to two portals depending on how many switches are active
      num_portals = [active_switches.length, 2].min

      # Try left and right
      positions = []
      if $game_map.passable?(boss_x - 1, boss_y, 0)
        positions.push([boss_x - 1, boss_y])
      end
      if $game_map.passable?(boss_x + 1, boss_y, 0)
        positions.push([boss_x + 1, boss_y])
      end

      # If blocked, just spawn on top
      if positions.empty?
        positions.push([boss_x, boss_y])
      end

num_portals.times do |i|
  pos = positions[i] || positions.last
  spawn_x, spawn_y = pos[0], pos[1]

# Determine portal color based on which switch triggered it
# active_switches is an array of IDs. We just pick the i-th one if multiple.
active_switch = active_switches[i] || active_switches.last

# Map switch ID to direction for the RIFT_PORTALS graphic
# Red: Down (2), Green: Left (4), Blue: Right (6), Yellow: Up (8)
portal_dir = 2
case active_switch
when SWITCH_RED
  portal_dir = 2
when SWITCH_GREEN
  portal_dir = 4
when SWITCH_BLUE
  portal_dir = 6
when SWITCH_YELLOW
  portal_dir = 8
end

target_map = RIFT_MAP_IDS.sample

# Trigger dynamic generation
if defined?(pbGenerateSingleRiftMap)
  pbGenerateSingleRiftMap(target_map)
end

# We spawn a temporary event to act as the portal.
if $game_map && $game_map.events
  # Find highest event ID and add 1
  new_id = ($game_map.events.keys.max || 0) + 1

  # Create script string for the portal
  script_str = "RiftChallenges.enter_and_transfer_rift(#{target_map}, self)" # Defaulting to middle of a 20x20 map

  # Build event (using existing pbBuildProceduralEvent from Map Generator if available)
  if defined?(pbBuildProceduralEvent)
    # Graphic is "RIFT_PORTALS" instead of "PortalGraphic", direction_fix is true, stop_anim is true
portal_event = pbBuildProceduralEvent(spawn_x, spawn_y, new_id, "Portal", "RIFT_PORTALS", 1, true, true, script_str, false, false)
portal_event.pages[0].graphic.direction = portal_dir if portal_event.pages[0] && portal_event.pages[0].graphic

# In Pokémon Essentials, appending a game_event to $game_map.events might not instantly
# draw the sprite if the Scene_Map spriteset has already been initialized.
# To force the sprite to appear immediately on the current map without a refresh/transfer:
game_event = Game_Event.new($game_map.map_id, portal_event, $game_map)
$game_map.events[new_id] = game_event
$game_map.need_refresh = true

# Tell Spriteset_Map to explicitly create a sprite for our newly injected events
if $scene && $scene.is_a?(Scene_Map)
  $scene.disposeSpritesets if $scene.respond_to?(:disposeSpritesets)
  $scene.createSpritesets if $scene.respond_to?(:createSpritesets)
end


  else
     # Fallback if map gen not loaded in context

       pbMessage(_INTL("A dimensional Rift has torn open at ({1}, {2})!", spawn_x, spawn_y))
    end
  end
  pbMessage(_INTL("A dimensional Rift has torn open at ({1}, {2})!", spawn_x, spawn_y))
end


    end
  end
end