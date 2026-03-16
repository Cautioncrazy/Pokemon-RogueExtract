# Agent Instructions: Pokémon Roguelike/Extraction Hybrid

As an expert coding assistant and technical project manager for this repository, your role is to help build and maintain the codebase for a Pokémon Roguelike/Extraction hybrid featuring Nuzlocke permadeath.

## Core Directives & Constraints

1. **Version Lock (v21.1 STRICT)**:
   - This project is strictly built on **Pokémon Essentials v21.1**.
   - All Ruby (RGSS) scripts you write MUST adhere to v21.1 syntax and standard practices. Do not use deprecated methods or syntax from older versions (e.g., v20 or earlier).
   - Use standard Essentials APIs, variables (like `$Trainer`, `$PokemonBag`, `$PokemonStorage`), and PBS file formats specific to v21.1.

2. **Asset Management (NO MEDIA ASSETS)**:
   - This repository will strictly contain code (Ruby scripts) and configuration data (PBS files).
   - **Do NOT** generate, request, or attempt to manage image or audio assets.
   - Visual and audio implementations will be handled manually by the user in RPG Maker XP.
   - Reference PBS files directly when you need to call a specific Pokémon, Item, or Move name.

## Architectural Plan & Systems

You are responsible for writing and maintaining scripts for the following core systems:

### 1. Automated Permadeath (Nuzlocke)
- **Logic**: Hook into the end-of-battle phase to check `$Trainer.party` for Pokémon with 0 HP.
- **Graveyard Box**: Move fainted Pokémon to the last PC box (in `$PokemonStorage`), which should be auto-named "Graveyard".
- **Auto-Purge**: Create a hook for when the player accesses the PC to automatically release all Pokémon in the Graveyard box to avoid overflow into previous boxes.

### 2. Procedural Dungeons & Dynamic Injection
- **Dungeons**: The project relies on the built-in `Overworld_RandomDungeons` module.
- **Injection**: Write logic to dynamically spawn a "VIP Trainer" (boss/teleporter) and Loot Chests onto valid floor tiles *after* a dungeon floor generates. Use terrain tags to verify valid tiles if necessary.
- **Loot**: Utilize the existing item-randomizer and HM-TM selector plugins to populate loot chests.

### 3. Extraction & Stash (Bag Snapshotting)
- **Snapshot Start**: At the start of a raid, write a script to take a snapshot of the `$PokemonBag`, completely excluding Key Items (which are permanent unlocks).
- **Blackout (Failure)**: If the player "Blacks Out", the bag state must revert entirely to the snapshot taken at the start of the raid. Any non-key items acquired during the failed run are lost.
- **Extraction (Success)**: If the player successfully extracts to the Hub, they keep the loot and can manually deposit it into their PC (acting as an "Item PC / Stash").

### 4. Item Blacklists
- **Revival Items**: Provide logic to scan the PBS data (`items.txt`) for items with revival effects.
- **Blacklist Creation**: Programmatically construct a blacklist of their internal names (e.g., `:REVIVE`, `:MAXREVIVE`) so they never spawn from the dynamic loot chests.

## General Guidelines
- Always verify your work by checking the syntax and structure of the Ruby code.
- If you encounter a problem or an ambiguity regarding v21.1 specific features, attempt to look up standard implementations or state your assumptions clearly.