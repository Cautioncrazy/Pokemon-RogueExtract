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
- **Usage**:
  1. Ensure `PyQt6` is installed (`pip install PyQt6`).
  2. Run `python tools/pbs_generator/main.py` from the root of the repository.
  3. Use the GUI for **bulk generation** by specifying:
     - **Start Map ID** & **End Map ID**: The range of maps to generate data for.
     - **Number of Floors**: The number of versions/floors each map in the range will have generated.
     - **Floor Theme**: Select a specific theme or use "Random".
     - **Apply Selected Theme to All Maps**: A toggle checkbox. If checked, it applies the exact selected theme to all floors. If the selected theme is "Random", it will pick a *new* random theme for *every* individual floor. If the checkbox is unchecked, it completely ignores the dropdown and forces a *new* random theme for *every* individual floor.
- **Role**: As the agent, you are responsible for maintaining and expanding these Python tools alongside the standard Ruby scripts, ensuring the custom parser remains intact and never falls back to standard `configparser` or `json` libraries.

### 8. Core Engine Scripts
- **Documentation**: See `scripts.md` in the repository root for the full documentation regarding the extracted engine scripts.
- **Directory Path**: The core engine scripts are located at `Data/Scripts/`.
- **Foundation First**: These extracted scripts are the foundation stones of the game. Whenever you are tasked with modifying core battle logic, map generation, UI elements, or item handling, you **must** prioritize referencing the native architecture found within this directory to ensure complete compatibility.
- **Structural Integrity & RGSS Syntax**: It is your responsibility to reference these files to maintain structural integrity and adhere to the proper RGSS syntax and standard practices established in Pokémon Essentials v21.1.
