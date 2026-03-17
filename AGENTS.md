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
- **Dungeons**: The project relies on the built-in `Overworld_RandomDungeons` module triggered via `Dungeon = true` map metadata.
- **Valid Tile Detection**: Since standard static events spawn in walls on dynamically generated maps, we use a mobile-optimized random coordinate sampler to hook into the generator. The script scans tiles via a dual-check: passability (`passable?`) and predefined Terrain Tags (e.g., standard floor tags) to prevent heavy full-map iteration loops.
- **Event Teleportation**: Dynamic entities are identified by parsing their RPG Maker Event Name (e.g., "VIP", "Trainer", "Chest") and teleported to valid coordinates using `.moveto(x, y)` right as the map loads.
- **Loot**: Utilize the existing item-randomizer and HM-TM selector plugins to populate loot chests.

### 3. Extraction & Stash (Bag Snapshotting)
- **Snapshot Start**: At the start of a raid, write a script to take a snapshot of the `$PokemonBag`, completely excluding Key Items (which are permanent unlocks).
- **Blackout (Failure)**: If the player "Blacks Out", the bag state must revert entirely to the snapshot taken at the start of the raid. Any non-key items acquired during the failed run are lost.
- **Extraction (Success)**: If the player successfully extracts to the Hub, they keep the loot and can manually deposit it into their PC (acting as an "Item PC / Stash").

### 4. Item Blacklists
- **Revival Items**: Provide logic to scan items for revival effects.
- **Blacklist Creation**: Programmatically construct a blacklist of their internal names (e.g., `:REVIVE`, `:MAXREVIVE`) so they never spawn from the dynamic loot chests. Must adhere to the Data Compilation Rule (use GameData APIs, not raw txt parsing during gameplay).

## General Guidelines
- Always verify your work by checking the syntax and structure of the Ruby code.
- If you encounter a problem or an ambiguity regarding v21.1 specific features, attempt to look up standard implementations or state your assumptions clearly.