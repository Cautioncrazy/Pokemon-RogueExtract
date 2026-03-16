# Pokémon Roguelike/Extraction Hybrid

Welcome to the **Pokémon Roguelike/Extraction Hybrid** project! This repository contains the code and data modifications for a unique take on Pokémon Essentials, combining roguelike dungeon crawling, extraction shooter loot mechanics, and Nuzlocke permadeath rules.

## Core Gameplay Loop

### Procedural Dungeons
The game leverages Pokémon Essentials' built-in `Overworld_RandomDungeons` module. Dungeons are generated procedurally, and players must navigate through floors, battling encounters and gathering loot.

### Dynamic Injection
After a dungeon floor generates, the game dynamically spawns "VIP Trainers" (bosses or teleporters) and Loot Chests. Loot chests are populated using custom item/TM randomizer plugins, ensuring a varied experience every run.

### Extraction & Stash
At key points, players can choose to **Continue** deeper into the dungeon or **Extract** to return to the Hub.
* **Snapshotting**: The player's Bag is snapshotted at the start of a raid.
* **Blackout**: If the player blackouts (loses all Pokémon), their Bag reverts to the snapshot, losing any non-Key Items found during the run.
* **Extracting**: Successful extraction secures the loot, allowing the player to deposit it in the standard Pokémon PC, which serves as both an "Item PC" and "Stash".

### Automated Permadeath (Nuzlocke)
Any Pokémon in the player's party that hits 0 HP is considered permanently dead. At the end of every battle, fainted Pokémon are automatically moved to the "Graveyard" PC box. Whenever the player accesses the PC, the Graveyard box is automatically purged (Pokémon are released) to prevent overflow.

### Item Blacklists
To maintain the integrity of the permadeath rules, revival items (e.g., Revive, Max Revive) are blacklisted and dynamically prevented from spawning in loot chests by scanning the item PBS data for revival effects.

## Project Constraints
* **Version Lock**: Strictly built on **Pokémon Essentials v21.1**. All Ruby (RGSS) scripts adhere to v21.1 syntax.
* **Asset Management**: This repository strictly contains code, scripts, and PBS files. Visual and audio implementation is handled manually in RPG Maker XP. Reference PBS files directly when calling specific Pokémon, Item, or Move names.