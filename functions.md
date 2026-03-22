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
*   **`pbDynamicTrainer(*args)`** (Alias for `pbSetAndStartDynamicTrainer`)
    *   **Description:** An all-in-one smart dynamic trainer generator for **BOTH** standard trainers and VIP bosses. It automatically selects a unique trainer from the global pool, updates the graphic instantly on map load, then automatically sets **Self Switch 'D' to ON** to transition to an interactive battle page. If the event is named "VIP", it natively detects this and pulls from the `DYNAMIC_VIPS` pool instead. It safely skips regeneration on subsequent calls, shows the battle message, and triggers the victory switch (e.g., 'A') upon winning.
    *   **Usage (Standard Trainers & VIPs):** Use the exact same 3-page event structure. *(Note: To make it a boss, simply name the event "VIP" in the top-left of the editor).*
        *   **Page 1 (Setup):** Set Trigger to `Parallel Process`. No graphic. Add script `pbDynamicTrainer("A")` (or `pbDynamicTrainer` if you want it to default to Self Switch A). If you only want specific types, you can pass them like this: `pbDynamicTrainer(:YOUNGSTER, :LASS, "A")`.
        *   **Page 2 (Battle):** Condition: `Self Switch D = ON`. Set Trigger to `Action Button`. Add the *exact same script command*.
        *   **Page 3 (Defeated):** Condition: `Self Switch A = ON`. Set Trigger to `Action Button`.
*   **`pbDefeatedVIP`**
    *   **Description:** Triggers a prompt asking the player if they want to "Extract" their loot or "Continue" deeper. Automatically calls `pbExtractRaidVIP` or `pbAdvanceRaid` based on their answer.
    *   **Usage:** Place this inside the `Script...` box on **Page 3** of your VIP event (the defeated NPC page). When the player interacts with the defeated boss, this prompt will allow them to extract safely.

---

### **3. Hardcore Replacements**
*(Located in `005_Hardcore_Pokemon_Pool.rb`)*

*   **`pbChooseHardcorePokemon`**
    *   **Description:** Returns the internal symbol (e.g., `:RATTATA`, `:RIOLU`) of a randomly chosen Pokémon based on the weighted `HARDCORE_STARTER_POOL` ratio (90-95% common, 5-10% rare).
    *   **Usage:** Rarely used manually, but available if you want to spawn the specific Pokémon on the overworld before giving it.
*   **`pbGiveHardcoreStarter`**
    *   **Description:** Instantiates a Level 5 Pokémon from the `HARDCORE_STARTER_POOL` and directly adds it to the player's party.
    *   **Usage:** Use this inside the autorun Event that triggers when `RAID_BLACKOUT_SWITCH` is turned ON (e.g., Steven giving you a new starter after your entire PC/Party wipes).
