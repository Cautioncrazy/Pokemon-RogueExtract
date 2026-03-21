# Roguelike Extraction - Custom Script Calls Cheat Sheet

This document outlines all of the custom script calls (the `pb...` methods) created for the Roguelike Extraction plugin. You can use these safely within the `Script...` command box of any RPG Maker XP Event. They are designed to be short to avoid the text-box width limit crashes in RPG Maker XP.

---

### **1. Raid State & Progression**
*(Located in `003_Raid_Tracker.rb`)*

*   **`pbStartRaid`**
    *   **Description:** Starts a new run. Sets the player's current floor to 1, takes an inventory snapshot, disables mid-raid saving, and teleports them to the first dungeon map.
    *   **Usage:** Use this on an NPC in your Hub (e.g., Steven) when the player selects "Begin Raid".
*   **`pbAdvanceRaid`**
    *   **Description:** Increments the floor counter, calculates the scaling difficulty, creates a new Bag snapshot for standard extraction mechanics, and teleports the player to the next random dungeon map.
    *   **Usage:** Use this when a player steps on a staircase event or chooses to delve deeper after defeating a VIP.
*   **`pbExtractRaid`**
    *   **Description:** Safely concludes a run early. Secures all obtained loot, resets the current run entirely (back to Floor 0 and clears map self-switches), re-enables saving, and teleports the player back to the Hub.
    *   **Usage:** Use this when a player uses an Escape Rope item or interacts with an exit specifically designed to end the current run.
*   **`pbExtractRaidVIP`**
    *   **Description:** Extracts via the VIP, securing loot but keeping the player's current floor progress (they do not revert to Floor 0). Resets the self-switches for the current floor only, allowing them to resume from the next floor later.
    *   **Usage:** Use this in a specific event that calls the VIP extract method so the player can continue their progress later.
*   **`pbBlackoutRaid`**
    *   **Description:** Fails the current run. Depending on whether Hardcore Mode is enabled, this will either wipe the player's Bag/Party completely or revert their Bag to the floor's initial snapshot, and then teleports them to the Hub. *(Note: This is automatically called if all Pokémon faint in battle).*
    *   **Usage:** Use this if you have traps or environmental hazards that instantly kill the player outside of battle.

---

### **2. Dynamic Dungeon Interactions**
*(Located in `006_Dynamic_Spawns_And_Scaling.rb`)*

*   **`pbDynamicChestLoot`**
    *   **Description:** Gives the player a scaled item based on their current floor depth (e.g., Potions on F1 -> Full Restores on F10) and automatically toggles the Event's `Self Switch A` to ON.
    *   **Usage:** Create a template Chest Event on your dungeon maps. On Page 1, add the `Script...` command `pbDynamicChestLoot`. On Page 2, set the condition to `Self Switch A is ON` and change the graphic to an open chest.
*   **`pbDynamicTrainerBattle(is_vip = false)`**
    *   **Description:** Dynamically draws a random trainer from `DYNAMIC_TRAINERS` (or `DYNAMIC_VIPS` if `is_vip` is set to `true`). It instantly replaces the event's overworld graphic with `trainer_{type}.png`, calculates the scaling difficulty, prevents duplicate trainer spawns, and initiates the battle.
    *   **Usage:** Create a standard Trainer Event. Setup a Conditional Branch checking the `Script...` command `pbDynamicTrainerBattle` (or `pbDynamicTrainerBattle(true)` for bosses). Inside the "Win" outcome of the Conditional Branch, set `Self Switch A` to ON. Leave the "Else" (Loss) outcome completely empty so the game's native blackout sequence can handle deaths safely.
*   **`pbSetAndStartDynamicTrainer(possible_types, possible_names = nil, victory_switch = "A")`**
    *   **Description:** An all-in-one smart dynamic event trainer generator designed for a single **Parallel Process** event page. It updates the graphic to a random trainer class on map load, then automatically converts itself into an Action Button event to await the player for battle. It handles selecting the name/type, the pre-battle message, the battle itself, and triggering the victory switch upon winning.
    *   **Usage:** Create a standard event set to Parallel Process with no predefined graphic. Add the script `pbSetAndStartDynamicTrainer([:YOUNGSTER, :LASS, :HIKER], nil, "B")`. Upon map load, the event updates its graphic and waits. When interacted with, it battles and if won, sets Self Switch B to ON automatically.
*   **`pbDefeatedVIP`**
    *   **Description:** Triggers a prompt asking the player if they want to "Extract" their loot or "Continue" deeper. Automatically calls `pbExtractRaidVIP` or `pbAdvanceRaid` based on their answer.
    *   **Usage:** Place this directly underneath the `Control Self Switch A = ON` command inside the "Win" outcome of the Conditional Branch on your VIP Boss event.

---

### **3. Hardcore Replacements**
*(Located in `005_Hardcore_Pokemon_Pool.rb`)*

*   **`pbChooseHardcorePokemon`**
    *   **Description:** Returns the internal symbol (e.g., `:RATTATA`, `:RIOLU`) of a randomly chosen Pokémon based on the weighted `HARDCORE_STARTER_POOL` ratio (90-95% common, 5-10% rare).
    *   **Usage:** Rarely used manually, but available if you want to spawn the specific Pokémon on the overworld before giving it.
*   **`pbGiveHardcoreStarter`**
    *   **Description:** Instantiates a Level 5 Pokémon from the `HARDCORE_STARTER_POOL` and directly adds it to the player's party.
    *   **Usage:** Use this inside the autorun Event that triggers when `RAID_BLACKOUT_SWITCH` is turned ON (e.g., Steven giving you a new starter after your entire PC/Party wipes).
