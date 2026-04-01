#===============================================================================
# Persistent Artifacts & Dynamic Mining System
#===============================================================================

#===============================================================================
# 1. Mining Minigame Integration
#===============================================================================
# Inject :HOLLOWED_SOUL into the Mining Game loot pool if it doesn't already exist.
# Format: [Item, probability, graphic x, graphic y, width, height, pattern]
if defined?(MiningGameScene)
  # Ensure we only inject once
  unless MiningGameScene::ITEMS.any? { |item| item[0] == :HOLLOWED_SOUL }
    # Using graphic x=0, y=24 which might be a default red gem looking thing
    # if the custom tileset doesn't have it explicitly.
    # Since we can't easily add to the graphic sheet, we will reuse a suitable existing sprite slice
    # Graphic x=0, y=17 is a Star Piece chunk which looks nice, let's use that (3x3).
    # Wait, the prompt requested a 2x2 grid shape (`[1, 1, 1, 1]`) or 3x2 jagged shape.
    # Let's use graphic x=6, y=24 which is a Hard Stone 2x2 sprite
    MiningGameScene::ITEMS.push([:HOLLOWED_SOUL, 40, 6, 24, 2, 2, [1, 1, 1, 1]])
  end
end

#===============================================================================
# 2. Dynamic Mining Spot Spawner
#===============================================================================
# Helper to dynamically spawn mining spots on a procedural floor
def pbSpawnFloorMiningSpots(min_spots, max_spots)
  # Determine number of spots to spawn
  num_spots = rand(min_spots..max_spots)
  return if num_spots <= 0

  # Scan map for valid wall tiles (passable tile directly adjacent to an impassable wall)
  # A spot is valid if it's passable (terrain tag 0 usually, or just passable? true)
  # and the tile above it (y-1) is impassable.
  valid_spots = []

  width = $game_map.width
  height = $game_map.height

  for x in 1...(width - 1)
    for y in 1...(height - 1)
      # Check if current tile is passable
      passable = $game_map.passable?(x, y, 0) # 0 is down, doesn't matter much for general passability check
      if passable
        # Check if tile above is an impassable wall
        wall_above = !$game_map.passable?(x, y - 1, 0)

        # Make sure there is no event already there
        no_event = true
        $game_map.events.values.each do |event|
          if event.x == x && event.y == (y - 1)
            no_event = false
            break
          end
        end

        if wall_above && no_event
          valid_spots.push([x, y - 1]) # We place the event ON the wall tile
        end
      end
    end
  end

  return if valid_spots.empty?

  # Select random spots
  selected_spots = valid_spots.sample(num_spots)

  selected_spots.each do |spot|
    x, y = spot[0], spot[1]

    # Generate unique ID for the event
    new_id = 1
    new_id = $game_map.events.keys.max + 1 if !$game_map.events.empty?

    # Construct RPG::Event
    rpg_event = RPG::Event.new(x, y)
    rpg_event.id = new_id
    rpg_event.name = "Mining Spot"

    # Page 1 Setup (Active)
    page1 = RPG::Event::Page.new
    page1.trigger = 0 # Action Button
    page1.graphic.character_name = ""
    page1.step_anime = true
    page1.direction_fix = true
    page1.always_on_top = true # Renders the graphic OVER the impassable wall tile

    # As requested: "If possible i actually just want an animation use Graphics/Animations/Shiny.png"
    # Note: In RPG Maker XP, event graphics must exist in Graphics/Characters/.
    # We will set the character graphic to "Shiny", assuming the user has copied/renamed
    # a sparkling sprite sheet to Graphics/Characters/Shiny.png as requested.
    page1.graphic.character_name = "Shiny"
    page1.graphic.pattern = 0

    # Commands
    list = []
    # Play SE
    list.push(RPG::EventCommand.new(250, 0, [RPG::AudioFile.new("Mining ping", 80, 100)]))
    # Call mining game
    list.push(RPG::EventCommand.new(355, 0, ["pbMiningGame"]))
    # Set Self Switch A to erase
    list.push(RPG::EventCommand.new(123, 0, ["A", 0])) # Control Self Switch A = ON
    list.push(RPG::EventCommand.new(355, 0, ["$game_self_switches[[#{$game_map.map_id}, #{new_id}, 'A']] = true"]))
    list.push(RPG::EventCommand.new(655, 0, ["$game_map.need_refresh = true"]))
    list.push(RPG::EventCommand.new(0, 0, []))
    page1.list = list

    # Page 2 Setup (Erased)
    page2 = RPG::Event::Page.new
    page2.condition.self_switch_valid = true
    page2.condition.self_switch_ch = "A"
    page2.graphic.character_name = ""
    page2.trigger = 0
    page2.list = [RPG::EventCommand.new(0, 0, [])]

    rpg_event.pages = [page1, page2]

    # Create Game_Event instance and add to map
    event = Game_Event.new($game_map.map_id, rpg_event, $game_map)
    $game_map.events[new_id] = event
  end

  $game_map.need_refresh = true
end



#===============================================================================
# 3. The Hub Shop Logic
#===============================================================================
def pbArtifactShop
  max_floor = $game_variables[100] || 0

  # Define the artifacts and their unlock conditions/costs
  # Format: [Item_Symbol, Cost, Unlock_Floor, Max_Stacks]
  artifacts = [
    [:ARTIFACT_FORTUNE, 3, 5, 10],
    [:ARTIFACT_VITALITY, 5, 10, 10],
    [:ARTIFACT_WISDOM, 5, 15, 10]
  ]

  loop do
    souls_owned = $bag.quantity(:HOLLOWED_SOUL)
    pbMessage(_INTL("Welcome. I trade in lost souls.\\n(You have {1} Hollowed Souls)", souls_owned))

    commands = []
    real_indices = []

    artifacts.each_with_index do |art, index|
      item_id = art[0]
      cost = art[1]
      unlock_floor = art[2]
      max_stacks = art[3]

      if max_floor >= unlock_floor
        item_name = GameData::Item.get(item_id).name
        owned = $bag.quantity(item_id)

        # Formatting the command string
        cmd_text = sprintf("%s (Cost: %d) [Owned: %d/%d]", item_name, cost, owned, max_stacks)
        commands.push(cmd_text)
        real_indices.push(index)
      end
    end

    commands.push(_INTL("Cancel"))

    choice = pbMessage(_INTL("What would you like to purchase?"), commands, -1)

    break if choice < 0 || choice == commands.length - 1

    # Process purchase
    selected_art = artifacts[real_indices[choice]]
    item_id = selected_art[0]
    cost = selected_art[1]
    max_stacks = selected_art[3]
    owned = $bag.quantity(item_id)

    if owned >= max_stacks
      pbMessage(_INTL("You already have the maximum number of that artifact."))
    elsif souls_owned < cost
      pbMessage(_INTL("You do not have enough Hollowed Souls."))
    else
      if pbConfirmMessage(_INTL("Purchase {1} for {2} Hollowed Souls?", GameData::Item.get(item_id).name, cost))
        $bag.remove(:HOLLOWED_SOUL, cost)
        $bag.add(item_id, 1)
        pbSEPlay("Item get")
        pbMessage(_INTL("You received {1}!", GameData::Item.get(item_id).name))
      end
    end
  end
end



#===============================================================================
# 4. Battle Mechanic Hooks (Ruby Math)
#===============================================================================

# Hook into Money Gain (Fortune Coin)
# Safe Class Eval for Battle class
class Battle
  # Alias for Fortune Coin (Money)
  unless method_defined?(:pbGainMoney_artifact_fortune)
    alias pbGainMoney_artifact_fortune pbGainMoney
    def pbGainMoney
      original_money = $player.money
      pbGainMoney_artifact_fortune

      # Determine how much was actually gained
      gained = $player.money - original_money
      if gained > 0
        stacks = $bag.quantity(:ARTIFACT_FORTUNE)
        if stacks > 0
          bonus = (gained * (0.25 * stacks)).floor
          if bonus > 0
            # Ensure we don't exceed max money
            max_money = Settings::MAX_MONEY || 9_999_999
            actual_bonus = [bonus, max_money - $player.money].min
            $player.money += actual_bonus
          end
        end
      end
    end
  end
end

# Alias for Wisdom Crystal (EXP)
# In order to safely and universally apply the Wisdom Crystal's multiplier to all Pokémon
# regardless of held items, we must alias `pbGainExpOne` directly and intercept the EXP
# right after it is calculated but before it is permanently applied to the Pokémon and
# logged to `$stats`. To do this cleanly without breaking the massive internal level-up loop,
# we use a `class_eval` alias chain that temporarily hijacks the `pkmn.growth_rate.add_exp`
# method call OR we just inject directly into the core engine script.
# Since modifying core scripts directly is cleaner for this specific hook, we will patch
# `Data/Scripts/011_Battle/001_Battle/003_Battle_ExpAndMoveLearning.rb` instead of aliasing here.

# Hook into Post-Battle Healing (Vitality Root)
EventHandlers.add(:on_end_battle, :artifact_vitality,
  proc { |decision, canLose|
    # decision: 1=win, 2=loss, 3=draw, 4=fled, 5=caught
    # Only heal if survived the battle (win or caught)
    if decision == 1 || decision == 5
      stacks = $bag.quantity(:ARTIFACT_VITALITY)
      if stacks > 0
        heal_percent = 0.05 * stacks
        $player.party.each do |pkmn|
          # Skip egg, fainted, and cursed pokemon
          next if pkmn.egg? || pkmn.fainted?
          next if pkmn.is_cursed if pkmn.respond_to?(:is_cursed)

          # Heal HP
          heal_amount = (pkmn.totalhp * heal_percent).floor
          pkmn.hp = [pkmn.hp + heal_amount, pkmn.totalhp].min
        end
      end
    end
  }
)
