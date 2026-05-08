# Agent Instructions: Pokémon Roguelike/Extraction Hybrid

As an expert coding assistant and technical project manager for this repository, your role is to help build and maintain the codebase for a Pokémon Roguelike/Extraction hybrid featuring Nuzlocke permadeath.

## Core Directives & Constraints

1. **Version Lock (v21.1 STRICT)**:
   - This project is strictly built on **Pokémon Essentials v21.1**.
   - All Ruby (RGSS) scripts you write MUST adhere to v21.1 syntax and standard practices. Do not use deprecated methods or syntax from older versions (e.g., v20 or earlier).
   - Use standard Essentials APIs, variables (like `$player`, `$PokemonBag`, `$PokemonStorage`), and PBS file formats specific to v21.1.
   - In Pokémon Essentials v21.1, changing a switch state directly via code (e.g., `$game_switches[X] = false`) does not natively broadcast an `:on_game_switch_change` event across the engine. Event handlers listening for switch changes will fail silently unless triggered through standard RPG Maker event commands. Always use hardcoded logic or manual triggers for vital state changes.
   - In Pokémon Essentials v21.1, `pbPokemonMart` strictly expects an array of item symbols. It cannot accept nested arrays (e.g., `[item_symbol, custom_price]`) to dynamically override item prices.

2. **Hub-Based State Management**:
   - Map 77 is the static Hub. Whenever possible, use the act of returning to the Hub (via `extract`, `extract_vip`, or `blackout`) as the master trigger for resetting run-based variables, switches, and caches.
   - Additionally, use `$game_map && $game_map.map_id == 77` as the standard condition for UI restrictions or features that should only be accessible outside of dungeon runs.
   - **Hub Economy:** The TM Shop (`pbRaidMartTM`) strictly generates randomized TMs. HMs are intentionally excluded from the randomized Hub economy.

3. **Asset Management (NO MEDIA ASSETS)**:
   - This repository will strictly contain code (Ruby scripts) and configuration data (PBS files).
   - **Do NOT** generate, request, or attempt to manage image or audio assets.
   - Visual and audio implementations will be handled manually by the user in RPG Maker XP.
   - Reference PBS files directly when you need to call a specific Pokémon, Item, or Move name.
   - **Exception:** If user explicitly asks agent to manage image/audio files

4. **Plugin Management (meta.txt)**:
   - Any custom plugins created for the repository must include a `meta.txt` file in their directory (containing Name, Version, etc.), or else Pokémon Essentials will not load them.

## Mobile Deployment Standards (JoiPlay Optimization)

This project has a strict long-term deployment goal of mobile optimization via JoiPlay. You must adhere to the following standards:

1. **Script Efficiency**:
   - All Ruby (RGSS) scripts must be highly optimized.
   - **Strictly avoid** unnecessary parallel processes.
   - **Strictly avoid** heavy, nested array iterations or redundant loops (especially in loops handling procedural dungeon injection and permadeath party-sweeps).
   - Unoptimized code causes severe lag and battery drain on mobile CPUs. Use efficient data structures (like Hashes for lookups) and break out of loops early when conditions are met.

2. **Data Compilation Rule**:
   - Raw `.txt` PBS files will **never** be parsed at runtime in the mobile build.
   - The game will be pre-compiled on a PC to generate `.dat` files for deployment.
   - Do not write scripts that attempt to parse `PBS/*.txt` files dynamically during gameplay. If data needs scanning (like building an item blacklist), it must either occur during the PC compilation phase or rely on the pre-compiled GameData APIs (e.g., `GameData::Item.try_get(:ID)`).

## Core Architecture & Engine Quirks

- **Alpha Boss Loops & The Nuclear Kill-Switch:** When attempting to break procedural event loops (like Alpha Pokémon bosses) after a Deluxe Battle Kit (DBK) encounter, battle outcome evaluations might silently fail or get overridden. To permanently prevent infinite loops from overworld event touches, abandon Self-Switches entirely. Instead, use the engine's native `pbEraseThisEvent` command immediately after the battle concludes to physically delete the event from the map memory for the remainder of the session.
- **Strict Prohibition on UI Elements in Generators:** Never trigger UI elements like `pbMessage` during procedural generation hooks or auto-spawners (such as `pbSetAndStartDynamicTrainer`, `get_dynamic_typeless_pool`, or `pbSpawnFloorMiningSpots`). All dynamic trainers and procedural events start with a parallel process page to set up their internal configurations and physical graphics before activating. Triggering a text box during this initialization sequence immediately traps the engine in a catastrophic, infinite text box loop. Always log debugging outputs silently to physical text files (like `debug_theme.txt` or `joiplay_crash_log.txt`).

## Architectural Plan & Systems

You are responsible for writing and maintaining scripts for the following core systems:

### 1. Automated Permadeath (Nuzlocke)
- **Logic**: Hook into the end-of-battle phase to check `$player.party` for Pokémon with 0 HP.
- **Graveyard Box**: Move fainted Pokémon to the last PC box (in `$PokemonStorage`), which should be auto-named "Graveyard" (spilling over to previous boxes if full).
- **Auto-Purge**: Hook into the `pbPokeCenterPC` access method to automatically release all Pokémon in any "Graveyard" box before the interface opens, avoiding overflow.

### 2. Procedural Dungeons & Dynamic Injection (Spawning)
- **Dynamic Trainer Management System**: A new helper function, `pbSetAndStartDynamicTrainer`, simplifies event setups. This function randomizes the trainer's class/name using predefined pools in `017_Procedural_Encounters.rb`, dynamically constructs purely in-memory `NPCTrainer` and `Pokemon` objects to skip PBS compilation, modifies their map graphic on the fly, shows the battle message, and initiates the battle via `TrainerBattle.start`. This removes the need for multiple parallel processes on a per-event basis and removes dependency on Python PBS generation for trainers.
- **Dungeons**: The project relies on the built-in `Overworld_RandomDungeons` module triggered via `Dungeon = true` map metadata. Dynamic event density is mathematically scaled during mass map generation so that early floors feel sparse, while deeper floors can be heavily populated.
- **Valid Tile Detection**: Since standard static events spawn in walls on dynamically generated maps, we use a mobile-optimized random coordinate sampler to hook into the generator. The script scans tiles via a dual-check: passability (`passable?`) and predefined Terrain Tags (e.g., standard floor tags) to prevent heavy full-map iteration loops.
- **Event Teleportation**: Dynamic entities are identified by parsing their RPG Maker Event Name (e.g., "VIP", "Trainer", "Chest") and teleported to valid coordinates using `.moveto(x, y)` right as the map loads.
- **Loot**: Utilize the existing item-randomizer and HM-TM selector plugins to populate loot chests.

### 3. Extraction, Stash, and Raid Tracking
- **Raid Tracking**: Hook custom variables `current_raid_floor` and `raid_bag_snapshot` into `$PokemonGlobal` so they persist through saves. NPCs use `RoguelikeExtraction.resume_or_start_raid` to automatically check the floor and transfer the player via `pbFadeOutIn` to the appropriate map from a defined configuration hash.
- **Saving Constraint**: An `on_calling_save_screen` hook actively disables the player from saving their game mid-raid (`current_raid_floor > 0`) to prevent random dungeon regeneration and save-scumming.
- **Snapshot Start**: At the start of a raid (and each subsequent floor in Standard Mode), the script takes a hash snapshot of the `$PokemonBag` via `GameData::Item`, completely excluding Key Items.
- **Blackout (Failure)**: If the player calls `RoguelikeExtraction.blackout`, the penalty depends on the `HARDCORE_MODE_SWITCH`. In Standard, the bag reverts to the snapshot taken at the start of the floor. In Hardcore, the entire bag is wiped, remaining party members are moved to the Graveyard, and a random Pokémon from the PC is assigned as the new starter. If the PC is empty, the `RAID_BLACKOUT_SWITCH` triggers for a true soft reset.
- **Extraction (Success)**: If the player successfully extracts to the Hub (`RoguelikeExtraction.extract`), they keep the loot, the snapshot clears, the floor resets to 0, and they can manually deposit it into their PC.
- **Secure Pouch**: A custom `SECUREPOUCH` Key Item that interacts with its own `$PokemonGlobal.secure_pouch_items` array. Items placed in this pouch bypass blackout wipes entirely and are limited by `$PokemonGlobal.secure_pouch_capacity` (each stack counts as 1 slot).

### 4. Item Blacklists
- **Revival Items**: Provide logic to scan items for revival effects.
- **Blacklist Creation**: Programmatically construct a blacklist of their internal names (e.g., `:REVIVE`, `:MAXREVIVE`) so they never spawn from the dynamic loot chests. Must adhere to the Data Compilation Rule (use GameData APIs, not raw txt parsing during gameplay).

### 5. Random Selector Plugins
You should rely on the following existing custom randomizer script calls whenever possible:
- `pbChooseRandomPokemon(whiteList=nil, blackList=nil, addList=nil, base_only=true, choose_gen=nil)`
- `pbGiveRandomGeneralItem`
- `pbGiveRandomTM`
- `pbGiveRandomHM`
- `pbGiveRandomTMorHM`
- `pbGiveRandomTMorHM([:ITEMNAME])`

## General Guidelines
- Always verify your work by checking the syntax and structure of the Ruby code.
- If you encounter a problem or an ambiguity regarding v21.1 specific features, attempt to look up standard implementations or state your assumptions clearly.
- **Always** Append new functions in functions.md **DO NOT** overwrite the whole file with a single function!
 
### 6. Standardized Trainer Pools
- **Single Source of Truth**: The `trainers.md` file in the root directory is the absolute rulebook and central source of truth for all procedural trainer party generation.

### 6a. Procedural Attribute Themes
- **Overview**: Standard procedural floors without an elemental type suffix (e.g., standard cave or forest) utilize the `get_dynamic_typeless_pool` logic in `017_Procedural_Encounters.rb` instead of falling back to static lists. This creates dynamic attribute-based challenges.
- **RNG Sourcing**: The pool generator explicitly seeds the Ruby RNG (`srand(floor * 100)`) using the current floor number (`$PokemonGlobal.current_raid_floor`). This guarantees that if a theme (like `:HIGH_SPEED`) is selected for Floor 5, the entire floor generates using that consistent pool, ensuring consistent thematic cohesion across multiple spawners. The RNG must always be reset afterward (`srand`) to prevent downstream sequence predictability.
- **Adding New Themes**: Developers can expand the `chosen_theme` logic by defining a new symbol in the pool and adding a `when` condition to the `case` statement. The filter block iterates through `GameData::Species` where `sp` represents the species data object.
- **Cheat Sheet for `GameData::Species` Properties**:
  When checking for conditions in `get_dynamic_typeless_pool`, you can rely on the following standard v21.1 attributes on the `sp` object:
  - `sp.base_stats` (Hash of `:HP`, `:ATTACK`, `:DEFENSE`, `:SPEED`, `:SPECIAL_ATTACK`, `:SPECIAL_DEFENSE`)
  - `sp.egg_groups` (Array of symbols like `:Monster`, `:Water1`, `:Undiscovered`)
  - `sp.weight` (Integer: 100 = 10.0 kg)
  - `sp.height` (Integer: 10 = 1.0 m)
  - `sp.types` (Array of symbols like `[:FIRE, :FIGHTING]`)
  - `sp.catch_rate` (Integer from 1-255)
  - `sp.abilities` (Array of defined abilities like `[:OVERGROW, :CHLOROPHYLL]`)
- **Thematic Pools**: When generating, writing scripts for, or modifying the dynamic raid trainers in `PBS/trainers.txt`, you **must** strictly adhere to the thematic species pools assigned to each Trainer Class in `trainers.md`. Do not assign Pokémon outside of a class's designated theme (e.g., no Poochyenas for Hikers).
- **Dynamic Re-generation**: If the user requests a new generation of the dynamic raid trainers, check `trainers.md` for any changes first, then programmatically pull base species from those pools and mathematically evolve them based on the Run/Floor level (which is mapped to the trainer version: 0, 1, or 2 in `PBS/trainers.txt`).

### 7. Python PBS Automation
We use a custom Python tool suite located in `tools/pbs_generator/` to automate PBS data creation for roguelike floors.
- **Structure**:
  - `pbs_parser.py`: Custom, line-by-line parser designed to handle Pokémon Essentials v21.1 formatting safely, preserving duplicates and brackets.
  - `map_metadata_gen.py`: Appends new map blocks to `PBS/map_metadata.txt`.
  - `encounter_gen.py`: Generates weighted encounter tables in `PBS/encounters.txt`.
  - `trainer_gen.py`: Appends procedurally generated themed trainers to `PBS/trainers.txt`. *(Note: Largely deprecated in favor of on-the-fly in-memory generation via `017_Procedural_Encounters.rb`, but retained for legacy compilation).*
  - `main.py`: A Glassmorphism GUI (requires `PyQt6`) to drive the entire generation process easily.
  - `encounters.md` / `trainers.md`: Text definitions that act as rulesets mapping Themes (Grass, Poison, etc.) to valid Pokémon species and Trainer Classes.
- **Map Generation**:
  - **On-The-Fly Generation**: The old Python mass-generation tools and 008_Mass_Map_Generator are deprecated. Maps and encounters are generated strictly on-the-fly during runtime.
  - **Encounter Types**: All dynamically generated maps must strictly use `:Land` encounters, regardless of visual theme. This prevents hardcoded full-map cave encounters and allows custom terrain tags (like Sand/Grass) to act as optional combat zones.

### 8. External Utilities & Tools
- **Pokemon Factory Mobile Generator**: `tools/Pokemon_Factory_Mobile_Generator.html`
  - A mobile-first, responsive, single-file HTML/CSS/JS utility.
  - Generates the proper Ruby Hash syntax required by Zik's "Pokémon Factory" plugin for dynamic, on-the-fly Pokémon creation.
  - Supports inputs for stats, up to 4 moves, shiny status, custom IVs/Nature, and advanced plugin features like `hue_change` and `sprite_override`.
  - Includes a live sprite preview that utilizes PokeAPI/Showdown sprites and CSS `hue-rotate` filters to visualize the `hue_change` parameter before applying it in-game.

### 9. Core Engine Scripts & Mandatory Research
- **Documentation**: See `scripts.md`, `functions.md`, and all other `.md` files in the repository root. **Before starting a task or writing a script that hooks into the engine**, you must proactively scan and research these `.md` files. They contain the specific guidelines, context, and rules you need to execute properly.
- **Directory Path**: The core engine scripts are located at `Data/Scripts/`.
- **Never Guess UI Symbols**: When adding commands to standard Pokémon Essentials UI (like the Debug Menu, PC menus, or Party screen), never assume the internal registry symbol based on the in-game display name (e.g., "Other editors..." does not mean `:other_menu`). **You must explicitly search the decompiled scripts** (using `grep -ri "MenuHandlers.add" Data/Scripts/` or similar commands) to find the correct, hardcoded system symbol (e.g., `:editors_menu`).
- **Foundation First**: These extracted scripts are the foundation stones of the game. Whenever you are tasked with modifying core battle logic, map generation, UI elements, or item handling, you **must** prioritize referencing the native architecture found within this directory to ensure complete compatibility.
- **Structural Integrity & RGSS Syntax**: It is your responsibility to reference these files to maintain structural integrity and adhere to the proper RGSS syntax and standard practices established in Pokémon Essentials v21.1.

### 10. Animation Merging Tool
We use a custom in-engine Ruby script located in `Plugins/AnimationMerger/` to automatically merge multiple community-made animation packs into the base `Data/PkmnAnimations.rxdata` file, ensuring the engine's default fallback animations are preserved.
- **Directory Scanning:** The script uses `Dir.glob` to scan the `Plugins/` directory and all its subdirectories for any file named `PkmnAnimations.rxdata`.
- **In-Game UI Priority Selection:** Accessible via the Debug menu > Other editors, the tool presents a UI loop to the user, allowing them to rank the priority of the found animation packs from Highest (1) to Lowest.
- **Merge Logic (Reverse Iteration):** The script first loads the vanilla base fallback file. It then iterates through the user-ranked custom packs starting with the lowest priority pack and ending with the highest priority pack.
- **Conflict Resolution:** If a custom pack contains an animation with the exact same name as one in the base array, it overwrites it. If it does not, the custom animation is appended to the end of the array. Applying the highest priority pack last ensures its animations permanently overwrite any lower-priority conflicts, while leaving untouched vanilla animations perfectly intact.
- Any engine performance plugins should live in the new hotfix plugin folder (`Plugins/Caution's 21.1 Hotfixes`), and reference the new readme.md in that directory.

### 11. Global Relic System (Risk of Rain Style)
- **Concept:** Players collect passive, stackable items ("Relics") during their run. These apply global buffs/modifiers to the entire party.
- **Data Structure:** Relics are implemented directly in `PBS/items.txt` in the standard Items pocket (`Pocket = 1`) to ensure native bag stacking. They use `SellPrice = 0` and `Flags = KeyItem` so they cannot be sold. To strictly prevent tossing (even in Debug mode), `PokemonBag_Scene#pbChooseNumber` and `pbConfirm` are aliased in `003_Relic_Spawner.rb` to actively block players from discarding these items.
- **Battle UI HUD:** The system hooks into `Battle::Scene` (`001_Relic_HUD.rb`). It creates a top-center, invisible-background HUD overlay during battles. It automatically scans the player's Bag for defined Relics and renders the corresponding item icon (`Graphics/Items/relic_name.png`) alongside a multiplier text counter (e.g., "x3").

### 12. Persistent Artifacts & Mining Spawner
- **Concept:** Players mine a custom Key Item currency ("Hollowed Soul") via the standard DPt Mining Minigame, which dynamically spawns on procedural floors. These souls are spent at a Hub Shop for "Persistent Artifacts"—stackable Key Items that provide permanent, global buffs for future runs.
- **Mining Integration:** `:HOLLOWED_SOUL` is injected into the standard mining loot pool (`MiningGameScene::ITEMS`) with a custom 2x2 grid shape and moderate spawn probability.
- **Dynamic Floor Spawner (`pbSpawnFloorMiningSpots`):** Scans the map during generation (or load) for passable tiles directly adjacent to impassable walls. It constructs a temporary, invisible `RPG::Event` (using the "Shiny" graphic if available) that triggers `pbMiningGame` upon interaction, then erases itself.
- **Hub Shop Logic (`pbArtifactShop`):** A custom UI loop (via `pbMessage` and `pbShowCommands`) allows players to purchase Artifacts. It checks `$game_variables[100]` (Max Floor Reached) to unlock higher-tier items, enforces a maximum stack limit (e.g., 10), and handles the currency exchange safely.
- **Stat Hooks:**
  - **Fortune Coin:** Aliases `Battle#pbGainMoney` to multiply end-of-battle payouts by `1 + (0.25 * stacks)`.
  - **Wisdom Crystal:** Aliases `Battle::ItemEffects.triggerExpGainModifier` to multiply all earned EXP by `1 + (0.15 * stacks)`.
  - **Vitality Root:** Hooks into `EventHandlers.add(:on_end_battle)` to heal all conscious, non-cursed party members by `5% * stacks` of their Max HP after a successful battle.

### 13. Extraction Bounties (Quest System)
- **Plugin Integration:** The project utilizes the "Modern Quest System + UI" plugin (Resource 709).
- **Data Configuration:** Quest data is defined natively within `Plugins/MQS/004_Quest_Data.rb` via the `QuestModule`. We use specific Stage descriptions to act as long-term goals without necessarily relying on multi-stage progression.
- **Progression Logic:** The quests (Bounties) track their numerical goals through native `$game_variables`:
  - **Slayer / Apex Predator:** Hooks into `pbSetAndStartDynamicTrainer` in `006_Dynamic_Spawns_And_Scaling.rb` to track defeated `is_vip` trainers.
  - **Gatherer:** Hooks into the end of `pbMiningGame` (`pbGiveItems` in `006_Minigame_Mining.rb`) to track mined `:HOLLOWED_SOUL`.
  - **Survivor:** Hooks into `pbAdvanceRaid` in `003_Raid_Tracker.rb` to check the `$PokemonGlobal.current_raid_floor` against the goal of Floor 20.
- **Bounty Board UI:** Handled by `pbBountyBoard` in `Plugins/Roguelike_Extraction/010_Bounty_Board.rb`. This allows players to activate and turn in quests. The logic supports:
  - **Repeatable Quests:** If a bounty (like Slayer) is completed, turning it in removes it from the completed log, dispenses the reward, and automatically re-activates it so the player can immediately farm it again.
  - **Tiered Milestone Chaining:** If a chained bounty (like Apex Predator I) is completed, turning it in dispenses the reward and automatically activates the next tier in the chain (Apex Predator II).
- **Start Menu UI Overrides:** In `Plugins/Roguelike_Extraction/011_Menu_Overrides.rb`, the standard "Quit Game" option is completely unregistered from the Pause Menu to prevent soft-resetting/save-scumming during a raid. A new "Bounties" option is injected to easily open the Quest UI anywhere.

### 13. Alpha Boss Battles (DBK UI Extension)
- **Concept:** Extends DBK's Wild Boss system by implementing a multi-bar HP system with custom UI iconography and animated scrolling pattern overlays to represent powerful Alpha Bosses.
- **Implementation (`Plugins/Roguelike_Extraction/012_Alpha_Boss_Visuals.rb`):**
  - **Trigger Hooks:** Actively checks DBK's native `isRaidBoss?` parameter (which validates the presence of the `:RAIDBOSS` immunity flag inside `pkmn.immunities`) to determine if a battler should receive the UI overlay, completely avoiding engine sanity-check failures.
  - **Visuals:** Mimics DBK's shadow pattern logic in `Sprite` and `PokemonSprite` to generate an animated scrolling pattern overlay (`alpha_pattern.png`) directly on the Alpha Pokémon's sprite during combat. It scrolls `:up` and `:right`.
  - **HP Multi-bar UI:** Overrides the DBK boss health bar rendering logic (`refresh_hp` in `Battle::Scene::PokemonDataBox`) to create a multi-tier "fighting game" style bar system. It calculates the active tier dynamically based on the boss's native `hp_level` (capped at 6).
    - **Native UI Masking Refactor:** To prevent custom texture blocks from squishing or bleeding outside the UI frame, Alpha Boss visuals now entirely rely on DBK's native UI masking (`@hpBarBitmap`) and `src_rect` clipping logic. Custom sprites and overrides were removed. Instead, the logic hijacks DBK's native Green/Yellow/Red colors cyclically (`active_color_index % 3`). The "Under-Bar" tier is rendered by drawing the lower tier color directly onto `self.bitmap` *before* the databox frame is drawn (`draw_background` alias). This forces DBK's native hollow databox graphic to perfectly clip and clamp the custom tier colors behind it.
    - **Data Pipeline Map:** Boss health tiers are fed through the Pokemon Factory, which has been updated to specifically map the `:hp_boost` hash attribute directly to the Pokémon's native DBK `hp_level` attribute during generation (`pkmn.hp_level = value`).
  - **UI Iconography:** Aliases DBK's `draw_style_icons` or `draw_special_form_icon` to draw a dedicated `alpha.png` icon next to the HP bar, mirroring the native approach used for Mega Evolution or Primal Reversion indicators.

### 14. Data Core Gacha (Pokémon Factory Hub System)
- **Concept:** A scalable custom hub scene that allows players to spend specific tier currencies (`DATACORE_COMMON`, `DATACORE_RARE`, `DATACORE_EPIC`) to roll RNG and generate customized starter Pokémon using the integrated Pokémon Factory plugin.
- **Implementation (`Plugins/Roguelike_Extraction/Gacha_Hub_System.rb`):**
  - **Gacha Pool Integration:** Hooks directly into `PokemonFactory.data` (which is populated by custom event hashes in `YOUR_EVENTS.rb`) to pull a randomized list of highly customized Pokémon configurations.
  - **Scene UI & Generation:** A lightweight, text-based UI scene handles the currency transaction. Upon spending a Data Core, it rolls RNG, uses `PokemonFactory.create(data)` to generate the custom Pokémon with unique moves/stats/hues.
  - **Custom Hatch Animation Hook:** If the rolled data hash contains an `:egg_type` parameter (e.g., `:COMMON`, `:EPIC`), the system triggers the custom standalone method `pbDataCoreHatchAnimation(pkmn, rarity_symbol)`. This mimics the native egg hatching sequence but loads a specific custom egg graphic (`Graphics/Pokemon/Eggs/#{rarity_symbol}.png`), overriding standard engine methods non-destructively, skipping Pokedex and nickname logic. It then deposits the newly rolled starter into the first 3 boxes of the PC for future deployments.

### 15. Factory Boss Spawning
- **Concept:** Integrates custom Pokémon from the Pokémon Factory into the roguelike loop as dynamic, wild boss encounters on the map, keeping them separate from the standard player Gacha pool.
- **Implementation:**
  - **Gacha Pool Exclusion (`Gacha_Hub_System.rb`):** The `pbDataCoreRoll` function filters out any Pokémon Factory keys starting with `"boss_"` to ensure players do not hatch Bosses from the Data Core Gacha.
  - **Map Generation (`008_Mass_Map_Generator.rb`):** Injects a procedural event named `"boss_pkmn"` (Event Touch Trigger) on the map alongside regular trainers and VIPs.
  - **Overworld Graphics (`002_Dynamic_Event_Spawner.rb`):** When the spawner detects a `"boss_pkmn"` event, it selects a random `"boss_"` key from the Factory, assigns it to `$PokemonGlobal.instance_variable_get(:@raid_event_bosses)`, and dynamically applies its overworld sprite (`boss_data[:sprite_override]` or species name) and `hue_change`.
  - **Battle Logic (`006_Dynamic_Spawns_And_Scaling.rb` & `012_DBK_Factory_Bridge.rb`):** Interacting with the event triggers `pbDynamicBossPokemon` (or `pbFightSpecificBoss` manually), which delegates to `pbFightFactoryBoss` in the bridge.
  - **DBK Wild Boss Bridge:** Native `Pokemon.new` initialization is performed before securely applying PokemonFactory data via `apply_attributes`. To interface with DBK properly (instead of using the hallucinated and invalid `setBattleRule("wildBoss")` approach), the bridge directly pushes `:RAIDBOSS` into the Pokémon's `immunities` array and maps `hp_level` so that DBK's `.isRaidBoss?` and Health Bar logic validate the generated entity.

### 16. Alpha Boss UI Expansion & Fading Syncs
- **Concept:** Natively leverages DBK to replace standard boss health bars with a scalable, custom multi-slice graphic (e.g., 6 tiers) while perfectly obeying DBK's viewport masking and battle transition fading rules.
- **Implementation (`Plugins/Roguelike_Extraction/012_Alpha_Boss_Visuals.rb`):**
  - **Height Clamping:** DBK aggressively applies 3-slice window heights to 6-slice graphics, causing visual bleeding. The UI hook strictly clamps `@hpBar.src_rect.height` using `(@hpBarBitmap.bitmap.height / 6).to_i` inside `draw_alpha_boss_ui`.
  - **Tier Lifecycle & Fading:** A secondary lazy-loaded sprite (`@underBar`) is drawn behind the active HP bar to indicate the next life. Aggressive aliasing of `opacity=` and `visible=` on both `PokemonDataBox` and `BossDataBox` ensures this under-bar correctly fades with the primary UI during move animations. When the boss reaches its final life (Tier 0), `@underBar.visible = false` is strictly enforced.
  - **Slide-In Delayed Creation:** To prevent the `Sprite.new` from flashing on screen for 1 frame and awkwardly popping out of nowhere before DBK's databox slide-in animation finishes, the under-bar utilizes delayed creation. It relies on `@alpha_creation_timer` (e.g., waiting 1200 frames to match the intro delay) inside `sync_alpha_overlay` before it is instantiated and mapped to the UI coordinates.
  - **Animated Sprite Overlays:** The Alpha boss visual pattern (`alpha_pattern`) avoids DBK's pattern system hooks (`Shadow Pokemon.rb`) and `setPokemonBitmap` entirely due to lethal `SystemStackError` cross-plugin recursion loops. It implements a native pattern masking architecture (`self.pattern`) that is lazily instantiated and animated safely inside the `BattlerSprite#update` loop. This completely bypasses initialization conflicts while guaranteeing perfect silhouette masking.

### 17. Dynamic Graphic Persistence
- **Concept:** Solves an engine visual bug where dynamic overworld graphics for Bosses and Trainers disappear and turn invisible after battles or map transfers (`$game_map.refresh` resets event pages in RAM, losing dynamically assigned graphics).
- **Implementation (`Plugins/Roguelike_Extraction/009_Dynamic_Graphic_Persistence.rb`):**
  - Aliases `Game_Event#refresh` to non-destructively intercept map reloads.
  - Reads the persistently cached trainer data in `$PokemonGlobal.instance_variable_get(:@dynamic_trainers)` for `[$game_map.map_id, @id]`.
  - Dynamically restores `@character_name = "trainer_#{chosen_type.to_s}"` and `@character_hue = 0`, ensuring the correct sprite persists even after the event has been defeated.

- **Automated Credits Tracking:** The script `scripts/update_credits.py` must be maintained and ran when a new plugin is added. It parses the `meta.txt` files across the `Plugins/` directory and outputs a sorted list of authors and their installed plugins to `credits.md` at the root of the project.
- **Battle Hooks:** Located in `002_Relic_Hooks.rb`, the system aliases native calculation modules to apply the buffs:
    - `pbCalcDamageMultipliers`: Scans for `RELIC_MUSCLE` to boost physical attack by 5% per stack.
    - `pbCalcAccuracyModifiers`: Scans for `RELIC_LENS` to boost accuracy by 5% per stack.
    - `pbStartWeather` & `pbStartTerrain`: Scans for `RELIC_EXTENDER` to boost the duration of weather/terrain moves by 1 turn per stack.
- **Loot Spawning & 3D Printer:** Located in `003_Relic_Spawner.rb`, `pbGiveRandomRelic` is designed to be called in chest/boss loot pools. `pb3DPrinterEvent` handles the interactive "3D Printer" feature, allowing players to feed owned relics to exchange them for a specific new relic generated by the event. The printer avoids trading a relic for the exact same relic. The `002_Dynamic_Event_Spawner.rb` handles spawning the printer procedurally in dungeons, similarly to the "Trader" NPC.

## Custom Status Conditions

We are expanding our combat system with custom volatile status effects that manipulate move selection. Currently implemented statuses are:
- **Fear** (Dragon): The afflicted Pokémon cannot select or execute damaging (Physical/Special) moves. It is initialized to 3 (lasts 3 turns).
- **Reckless** (Fighting): The afflicted Pokémon is forced to use attacking moves AND takes 1/8th of its max HP as recoil damage every time they successfully land an attack. It is initialized to 4 (lasts 4 turns).

**Core Script Hooks:**
- **Initialization:** Hooked in `Data/Scripts/011_Battle/002_Battler/002_Battler_Initialize.rb` within `pbInitEffects`.
- **Move Selection:** Blocked in `Data/Scripts/011_Battle/002_Battler/009_Battler_UseMoveSuccessChecks.rb` within `pbCanChooseMove?`.
- **Reckless Recoil:** Hooked into the end of a successful move execution in `Data/Scripts/011_Battle/002_Battler/010_Battler_UseMoveTriggerEffects.rb` within `pbEffectsAfterMove`.
- **Turn Ticking:** Handled in `Data/Scripts/011_Battle/001_Battle/011_Battle_EndOfRoundPhase.rb` within `pbEOREndBattlerEffects`.

## Expanded Type Status Conditions

The combat system features custom primary status conditions for each Pokémon type. These are defined in `GameData::Status` (`Data/Scripts/010_Data/001_Hardcoded data/010_Status.rb`) with unique `:id` and `:icon_position` attributes.

**Battle Mechanic Hooks:**
Mechanics for each custom status are integrated directly into the `Battle::Battler` and `Battle::Move` logic.
- **Bleeding** (Steel): Scales damage each turn exactly like Toxic. Hooked in `Data/Scripts/011_Battle/001_Battle/011_Battle_EndOfRoundPhase.rb` (`pbEORStatusProblemDamage`). It uniquely resets `PBEffects::Toxic` when inflicted.
- **Blindness** (Psychic): 20% chance to fail executing any move. Hooked in `Data/Scripts/011_Battle/002_Battler/009_Battler_UseMoveSuccessChecks.rb` (`pbTryUseMove`).
- **Shaken** (Ground): Halves physical Defense and reduces the critical hit stage by 1. Hooked in `Data/Scripts/011_Battle/003_Move/003_Move_UsageCalculations.rb` (`pbGetDefenseStats` via `pbCalcDamage` logic, and `pbIsCritical?`).

**Dynamic Type Immunity Framework:**
Immunities are managed dynamically in `Data/Scripts/011_Battle/002_Battler/004_Battler_Statuses.rb` (`pbCanInflictStatus?`).
A status condition is intrinsically tied to a specific Pokémon type via the `status_types` hash:
```ruby
status_types = {
  :BLEEDING  => :STEEL,
  :BLINDNESS => :PSYCHIC,
  :SHAKEN    => :GROUND
}
```
If a Pokémon attempts to inflict one of these mapped statuses, the framework automatically checks the target's types against the standard Type Effectiveness Chart (`Effectiveness.calculate`).
- **Same-Type Immunity:** If the target possesses the type mapped to the status, it is immune (e.g., Steel is immune to Bleeding).
- **Matchup Immunity:** If any of the target's types has a `0` effectiveness multiplier against the status's mapped type, it is immune (e.g., Dark is immune to Psychic, thus immune to Blindness. Flying is immune to Ground, thus immune to Shaken).

To add a new custom status for a different type, simply define it in `010_Status.rb`, add its mechanical hook where necessary, and add its Type mapping to the `status_types` hash in `pbCanInflictStatus?`.

**UI Icon Hardcoding:**
The default Essentials logic assumes the `Fainted`, `Pokérus`, and `Badly Poisoned` icons are always appended to the very bottom of the `Graphics/UI/statuses.png` and `Graphics/UI/Battle/icon_statuses.png` sheets. Because we are appending numerous custom types directly to the bottom of the graphic, this logic was overridden.
The files `Data/Scripts/016_UI/005_UI_Party.rb`, `006_UI_Summary.rb`, and `Data/Scripts/011_Battle/004_Scene/006_Battle_Scene_Objects.rb` have been explicitly updated to look for `Fainted` at position `5`, `Pokérus` at position `6`, and `Bad Poison` at position `5`. This allows appending an infinite amount of custom statuses vertically without having to manually shuffle Fainted/Pokerus to the new bottom position.

## Player Object Distinctions

**Critical difference between `$game_player` and `$player`:**
- `$game_player`: Used strictly for manipulating the player's representation in the overworld (e.g., movement routes, `.move_route_forcing`, `.through`, map coordinates).
- `$player`: Holds the player's trainer data (e.g., party, name, trainer card info). Do not attempt to call overworld manipulation methods on `$player`.

**Procedural Event Constraints:**
Never manually inject raw Event Command `208` (Change Transparent Flag) or `205` (Set Move Route) targeting the player in procedural event generators. Doing so permanently overrides and conflicts with the base engine's natural event handling (such as `pbNoticePlayer`), causing the player sprite to permanently disappear or lock up during encounters.

## Plugin Architecture & References

## 🛑 Behavioral & Execution Guidelines (JULES.md)

Before beginning any code generation or modification, you MUST read and internalize the guidelines established in `JULES.md`. 

While `AGENTS.md` and our API references dictate the **architecture** and **rules** of our Pokémon Essentials/DBK environment, `JULES.md` dictates exactly **how you are allowed to operate** within it. 

**Core Directives to Remember:**
1. **Behavior Override:** The constraints in `JULES.md` supersede your default LLM tendencies to over-engineer, over-explain, or proactively refactor unrelated code. 
2. **Surgical Precision:** When modifying existing Ruby scripts or UI elements, you are strictly forbidden from altering adjacent logic, comments, or formatting unless specifically instructed. 
3. **Stop & Ask:** If you are unsure about a specific DBK or other plugin methods, variables, or UI coordinates, DO NOT hallucinate a fallback. Stop the execution and ask for clarification.

Your success is measured by outputting the absolute minimum amount of code required to achieve the exact goal requested, with zero collateral changes to the surrounding codebase.


* **Deluxe Battle Kit (DBK):** The file `docs/DBK_API_REFERENCE.md` is our absolute source of truth for all Deluxe Battle Kit logic. You must keep its specific hooks (like `:RAIDBOSS` immunities, `isAlphaBoss?`, and UI aliases) in your active context for all future battle-engine tasks. Do not hallucinate vanilla Essentials rules for boss triggers.


## Difficulty Tier & Progression

**Floor Scaling & Progression (Risk of Rain Style)**
The species pool for procedurally generated wild encounters and trainers is actively scaled based on a time-based / progression-based 8-Tier difficulty system.
- This is controlled via `$game_variables[90]`.
- All encountered species are passed through `ProceduralEncounters.filter_pool_by_bst_tier`, which calculates the Base Stat Total (BST) of each Pokémon and filters them against the current Tier's bracket:
  - **Tier 1:** BST <= 320 (Early game bugs/birds)
  - **Tier 2:** BST 250 - 380
  - **Tier 3:** BST 300 - 430
  - **Tier 4:** BST 350 - 480
  - **Tier 5:** BST 400 - 520 (Mid-game staples)
  - **Tier 6:** BST 450 - 560
  - **Tier 7:** BST 480 - 600
  - **Tier 8:** BST >= 500 (Endgame / Pseudos)
- This ensures players do not encounter heavily overpowered or underpowered Pokémon for the current state of their run. The exact mathematical tiers can be adjusted within `Plugins/Roguelike_Extraction/017_Procedural_Encounters.rb`.

**Timer & HUD Overlay (018_Difficulty_HUD_Timer.rb)**
- The progression system is actively tied to a real-time ticking clock managed by `RoguelikeDifficultyHUD`.
- **Variables & Switches:**
  - `ROGUELIKE_RUN_ACTIVE_SWITCH` (Switch 90): Master switch. If OFF, the timer halts and the HUD hides. Toggling this from OFF to ON automatically resets the timer to 0 and the tier to 1. Triggered dynamically in `003_Raid_Tracker.rb` during run start, extraction, and wipe flows.
  - `TIMER_SECONDS_VAR` (Variable 91): Tracks the total elapsed real-time seconds of the run.
  - `DIFFICULTY_TIER_VAR` (Variable 90): Tracks the current 1-8 difficulty tier.
- **Scaling Interval:** The tier increases by 1 every 3 minutes (180 seconds).
- **Pause Conditions:** The timer automatically pauses (and the HUD hides) under specific conditions to ensure fair play: during battles, inside menus, when message boxes are active, when event scripts are running, or when the player is resting on the Hub Map (Map 77).
- **Terminal State:** Upon reaching Tier 8 ("Terminal"), the difficulty cap is hit, and the progress bar remains permanently filled at 100%.

## Rift Challenges Architecture

The Rift Challenge system is a dynamic, high-risk/high-reward instance generated at runtime.

### Hooks and Aliases
- **Wild Encounters:** `PokemonEncounters#choose_wild_pokemon` is safely aliased to force dynamic encounters based on Rift weather pools when the player is on a Rift Map (IDs 900-999).
- **Procedural Boss Factory:** We use `RiftChallenges.generate_dynamic_boss` to construct a hash mimicking the `PokemonFactory` data structure. We register this dynamically at runtime by assigning it directly to `ZBox::PokemonFactory.data` so `pbFightFactoryBoss` handles the Boss spawning correctly with DBK flags.
- **Portal Spawning:** Hooks into `pbDynamicBossPokemon` in `006_Dynamic_Spawns_And_Scaling.rb` to spawn a transfer portal when any of the specific Rift switches (130-133) are active.
- **Dynamic Bounties:** Driven by the Map Generation Manifest (`$PokemonGlobal.current_rift_manifest`) to create 100% completable objectives upon entry.

### Safety Rules
- When generating maps, the `Rift Manifest` must be explicitly populated. To avoid manifest overlapping across multiple portals, the map and manifest should be uniquely tied to the Map ID.
- Level scaling variables (99 and 100) are explicitly manipulated by incrementing upon entering the Rift and restoring from saved global instances (`@saved_trainer_var`, `@saved_wild_var`) upon exiting. DO NOT manipulate `LevelScalingSettings::DIFFICULTIES` directly.
- **Map Theme Prefixes:** Prefixes (like `forest_` or `cave_`) strictly dictate physical encounter terrain rules (e.g., `forest` restricts wild encounters only to tall grass tiles).
- **Map Theme Suffixes:** Suffixes (like `_ICE` or `_FIRE`) strictly dictate the Wild and Standard Trainer type pools.
- **Boss Trainers:** Boss Trainers must always generate using a type pool drawn from the weaknesses of the floor's theme suffix, ensuring they act as type counters to the floor's theme.
- **Dynamic Layout Injection:** In Pokémon Essentials (Overworld_RandomDungeons), procedural map generation relies on `$PokemonGlobal.dungeon_area` matching a layout key in `GameData::DungeonParameters` (e.g., `:cave_0`). If a suffixed theme (like `cave_FIRE`) lacks a specific parameter entry, the map generation fails or renders a black map unless a fallback clone is dynamically injected into `GameData::DungeonParameters::DATA` at runtime.
