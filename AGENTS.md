# Agent Instructions: Pokémon Roguelike/Extraction Hybrid

As an expert coding assistant and technical project manager for this repository, your role is to help build and maintain the codebase for a Pokémon Roguelike/Extraction hybrid featuring Nuzlocke permadeath.

## Core Directives & Constraints

1. **Version Lock (v21.1 STRICT)**:
   - This project is strictly built on **Pokémon Essentials v21.1**.
   - All Ruby (RGSS) scripts you write MUST adhere to v21.1 syntax and standard practices. Do not use deprecated methods or syntax from older versions (e.g., v20 or earlier).
   - Use standard Essentials APIs, variables (like `$player`, `$PokemonBag`, `$PokemonStorage`), and PBS file formats specific to v21.1.

2. **Asset Management (NO MEDIA ASSETS)**:
   - This repository will strictly contain code (Ruby scripts) and configuration data (PBS files).
   - **Do NOT** generate, request, or attempt to manage image or audio assets.
   - Visual and audio implementations will be handled manually by the user in RPG Maker XP.
   - Reference PBS files directly when you need to call a specific Pokémon, Item, or Move name.

3. **Plugin Management (meta.txt)**:
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

## Architectural Plan & Systems

You are responsible for writing and maintaining scripts for the following core systems:

### 1. Automated Permadeath (Nuzlocke)
- **Logic**: Hook into the end-of-battle phase to check `$player.party` for Pokémon with 0 HP.
- **Graveyard Box**: Move fainted Pokémon to the last PC box (in `$PokemonStorage`), which should be auto-named "Graveyard" (spilling over to previous boxes if full).
- **Auto-Purge**: Hook into the `pbPokeCenterPC` access method to automatically release all Pokémon in any "Graveyard" box before the interface opens, avoiding overflow.

### 2. Procedural Dungeons & Dynamic Injection (Spawning)
- **Dynamic Trainer Management System**: A new helper function, `pbSetAndStartDynamicTrainer`, simplifies event setups. This function randomizes the trainer's class/name, modifies their map graphic on the fly, shows the battle message, and initiates the battle. This removes the need for multiple parallel processes on a per-event basis.
- **Dungeons**: The project relies on the built-in `Overworld_RandomDungeons` module triggered via `Dungeon = true` map metadata.
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
### 6. Standardized Trainer Pools
- **Single Source of Truth**: The `trainers.md` file in the root directory is the absolute rulebook and central source of truth for all procedural trainer party generation.
- **Thematic Pools**: When generating, writing scripts for, or modifying the dynamic raid trainers in `PBS/trainers.txt`, you **must** strictly adhere to the thematic species pools assigned to each Trainer Class in `trainers.md`. Do not assign Pokémon outside of a class's designated theme (e.g., no Poochyenas for Hikers).
- **Dynamic Re-generation**: If the user requests a new generation of the dynamic raid trainers, check `trainers.md` for any changes first, then programmatically pull base species from those pools and mathematically evolve them based on the Run/Floor level (which is mapped to the trainer version: 0, 1, or 2 in `PBS/trainers.txt`).

### 7. Python PBS Automation
We use a custom Python tool suite located in `tools/pbs_generator/` to automate PBS data creation for roguelike floors.
- **Structure**:
  - `pbs_parser.py`: Custom, line-by-line parser designed to handle Pokémon Essentials v21.1 formatting safely, preserving duplicates and brackets.
  - `map_metadata_gen.py`: Appends new map blocks to `PBS/map_metadata.txt`.
  - `encounter_gen.py`: Generates weighted encounter tables in `PBS/encounters.txt`.
  - `trainer_gen.py`: Appends procedurally generated themed trainers to `PBS/trainers.txt`.
  - `main.py`: A Glassmorphism GUI (requires `PyQt6`) to drive the entire generation process easily.
  - `encounters.md` / `trainers.md`: Text definitions that act as rulesets mapping Themes (Grass, Poison, etc.) to valid Pokémon species and Trainer Classes.
- **Automated Map Pipeline**: We employ a dual-script pipeline for generating procedural maps:
  1. **In-Engine (`.rxdata`)**: Open RPG Maker XP, run the game in Debug mode, and select `Other editors... -> Mass Generate RL Maps`. Input a Map ID range. This generates the physical `MapXXX.rxdata` files and links them to the editor registry (`MapInfos.rxdata`). **You must completely restart RPG Maker XP to see the new maps.**
      - *Tileset Naming & Theme Bridging*: The Ruby script randomly assigns a tileset to each new map. It ONLY selects tilesets whose names strictly begin with `Dungeon`. If the tileset name contains a theme suffix (e.g., `Dungeon forest_ICE`), the Ruby script writes this map-to-theme mapping into `tools/pbs_generator/map_themes.json`.
  2. **PBS Metadata (`map_metadata.txt`)**: Use the Python GUI tool to mass-generate the corresponding metadata. The tool automatically injects random names, the `Dungeon = true` flag, and randomly selects a BGM by scanning the `Audio/BGM/` directory.
      - *Theme Overrides*: When you run bulk generation in the Python GUI, it natively reads `map_themes.json`. If a map has an assigned tileset theme (like `ICE`), it forcefully overrides whatever "Floor Theme" you selected in the GUI dropdown, guaranteeing that map's encounters and trainers match its physical tileset.

- **Usage**:
  1. Ensure `PyQt6` is installed (`pip install PyQt6`).
  2. Run `python tools/pbs_generator/main.py` from the root of the repository.
  3. Use the GUI for **bulk generation** by specifying:
     - **Start Map ID** & **End Map ID**: The range of maps to generate data for.
     - **Number of Floors**: The number of versions/floors each map in the range will have generated.
     - **Floor Theme**: Select a specific theme or use "Random".
     - **Apply Selected Theme to All Maps**: A toggle checkbox. If checked, it applies the exact selected theme to all floors. If the selected theme is "Random", it will pick a *new* random theme for *every* individual floor. If the checkbox is unchecked, it completely ignores the dropdown and forces a *new* random theme for *every* individual floor.
     - **Step Chance Config**: Defines the encounter step chance increment. You input a min chance (e.g., 5%), max chance (e.g., 20%), and a "Chunk" size. Floors are grouped into these chunks, and the step chance linearly scales from min to max across the total number of chunks.
     - **Index Filter**: An optional semantic filter powered by `pokemon_index.json`. You can select a category (e.g., `bst_tier`, `encounter_rarity`) and a value (e.g., `earlygame`, `legendary`) to restrict the pool of generated Pokémon. The filter applies natively to Wild Encounters and features an automated fallback system (e.g., trying `midgame` if `earlygame` yields 0 Pokémon) to guarantee generation. You can toggle whether this filter also applies to procedurally generated Trainer Parties.
     - **Boss Generation**: Controls if Boss trainers are generated (`Include Boss`, `Exclude Boss`, or `Only Boss`). When generated, Boss trainers receive the `"Boss "` name prefix, a +1 party size increase, +2 level boost, unique LoseText, and a guaranteed set of healing items that scale with the floor depth (e.g., `POTION` on F1, scaling up to `FULLRESTORE,SITRUSBERRY,LUMBERRY` on F13+). Standard trainers also have a 50% chance to receive slightly weaker, slower-scaling items.
     - **Overwrite Existing Data**: If checked, the tool actively finds and deletes matching PBS sections before rewriting them. **Important**: When overwrite is active, dynamic trainers are generated with deterministic names (e.g., `Boss M1_F5`) instead of random names (e.g., `Boss Alice`) to ensure the PBS parser can accurately locate and delete the specific previous procedural entry.
- **Role**: As the agent, you are responsible for maintaining and expanding these Python tools alongside the standard Ruby scripts, ensuring the custom parser remains intact and never falls back to standard `configparser` or `json` libraries.

### 8. Core Engine Scripts & Mandatory Research
- **Documentation**: See `scripts.md`, `functions.md`, and all other `.md` files in the repository root. **Before starting a task or writing a script that hooks into the engine**, you must proactively scan and research these `.md` files. They contain the specific guidelines, context, and rules you need to execute properly.
- **Directory Path**: The core engine scripts are located at `Data/Scripts/`.
- **Never Guess UI Symbols**: When adding commands to standard Pokémon Essentials UI (like the Debug Menu, PC menus, or Party screen), never assume the internal registry symbol based on the in-game display name (e.g., "Other editors..." does not mean `:other_menu`). **You must explicitly search the decompiled scripts** (using `grep -ri "MenuHandlers.add" Data/Scripts/` or similar commands) to find the correct, hardcoded system symbol (e.g., `:editors_menu`).
- **Foundation First**: These extracted scripts are the foundation stones of the game. Whenever you are tasked with modifying core battle logic, map generation, UI elements, or item handling, you **must** prioritize referencing the native architecture found within this directory to ensure complete compatibility.
- **Structural Integrity & RGSS Syntax**: It is your responsibility to reference these files to maintain structural integrity and adhere to the proper RGSS syntax and standard practices established in Pokémon Essentials v21.1.

### 9. Animation Merging Tool
We use a custom in-engine Ruby script located in `Plugins/AnimationMerger/` to automatically merge multiple community-made animation packs into the base `Data/PkmnAnimations.rxdata` file, ensuring the engine's default fallback animations are preserved.
- **Directory Scanning:** The script uses `Dir.glob` to scan the `Plugins/` directory and all its subdirectories for any file named `PkmnAnimations.rxdata`.
- **In-Game UI Priority Selection:** Accessible via the Debug menu > Other editors, the tool presents a UI loop to the user, allowing them to rank the priority of the found animation packs from Highest (1) to Lowest.
- **Merge Logic (Reverse Iteration):** The script first loads the vanilla base fallback file. It then iterates through the user-ranked custom packs starting with the lowest priority pack and ending with the highest priority pack.
- **Conflict Resolution:** If a custom pack contains an animation with the exact same name as one in the base array, it overwrites it. If it does not, the custom animation is appended to the end of the array. Applying the highest priority pack last ensures its animations permanently overwrite any lower-priority conflicts, while leaving untouched vanilla animations perfectly intact.
- Any engine performance plugins should live in the new hotfix plugin folder (`Plugins/Caution's 21.1 Hotfixes`), and reference the new readme.md in that directory.

### 10. Global Relic System (Risk of Rain Style)
- **Concept:** Players collect passive, stackable items ("Relics") during their run. These apply global buffs/modifiers to the entire party.
- **Data Structure:** Relics are implemented directly in `PBS/items.txt` as `KeyItems` (Pocket 8) so they cannot be tossed or sold but their quantity can natively stack.
- **Battle UI HUD:** The system hooks into `Battle::Scene` (`001_Relic_HUD.rb`). It creates a top-center, invisible-background HUD overlay during battles. It automatically scans the player's Bag for defined Relics and renders the corresponding item icon (`Graphics/Items/relic_name.png`) alongside a multiplier text counter (e.g., "x3").
- **Battle Hooks:** Located in `002_Relic_Hooks.rb`, the system aliases native calculation modules to apply the buffs:
    - `pbCalcDamageMultipliers`: Scans for `RELIC_MUSCLE` to boost physical attack by 5% per stack.
    - `pbCalcAccuracyModifiers`: Scans for `RELIC_LENS` to boost accuracy by 5% per stack.
    - `pbStartWeather` & `pbStartTerrain`: Scans for `RELIC_EXTENDER` to boost the duration of weather/terrain moves by 1 turn per stack.
- **Loot Spawning & 3D Printer:** Located in `003_Relic_Spawner.rb`, `pbGiveRandomRelic` is designed to be called in chest/boss loot pools. `pb3DPrinterEvent` handles the interactive "3D Printer" feature, allowing players to feed owned relics to exchange them for a specific new relic generated by the event. The printer avoids trading a relic for the exact same relic. The `002_Dynamic_Event_Spawner.rb` handles spawning the printer procedurally in dungeons, similarly to the "Trader" NPC.

## Expanded Type Status Conditions

The combat system features custom primary status conditions for each Pokémon type. These are defined in `GameData::Status` (`Data/Scripts/010_Data/001_Hardcoded data/010_Status.rb`) with unique `:id` and `:icon_position` attributes.

**Battle Mechanic Hooks:**
Mechanics for each custom status are integrated directly into the `Battle::Battler` and `Battle::Move` logic.
- **Bleeding** (Steel): Scales damage each turn exactly like Toxic. Hooked in `Data/Scripts/011_Battle/001_Battle/011_Battle_EndOfRoundPhase.rb` (`pbEORStatusProblemDamage`). It uniquely resets `PBEffects::Toxic` when inflicted.
- **Blindness** (Psychic): 67% chance to fail executing any move. Hooked in `Data/Scripts/011_Battle/002_Battler/009_Battler_UseMoveSuccessChecks.rb` (`pbTryUseMove`).
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
