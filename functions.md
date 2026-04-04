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

*   **`pbEarlyExtractPrompt`**
    *   **Description:** An interactable NPC event that allows the player to safely extract early. Like extracting at the Hub, it resets the floor to 0 but saves all the loot gathered so far.
    *   **Usage:** Used on the standard `Extract NPC` generated in procedural dungeons.

*   **`pbBlackMarketTrader`**
    *   **Description:** A shady NPC trader that rarely spawns (every 5-10 floors) and opens a custom `pbPokemonMart` filled with high-tier items (Revives, PP items, Choice items) unavailable at standard stores.
    *   **Usage:** Used on the standard `Trader NPC` generated in procedural dungeons.

---

### **3. Cursed Pokemon & Easy Mode**
*(Located in `007_Pokemon_Cursed_Starter.rb` & `003_Raid_Tracker.rb`)*

*   **`pbHealCursedPokemon`**
    *   **Description:** Checks the player's party for any cursed Pokémon (acquired from an Easy Mode blackout/wipe). Calculates a revival cost based on the number of cursed Pokémon and the depth of the last failed raid floor (`200 * cursed_count * last_raid_floor`). If the player accepts and pays, it fully heals them and removes the curse/Heart marking.
    *   **Usage:** Use this in an NPC Event (e.g., a shady individual near Nurse Joy in the Hub) to offer the player a way to revive their dead Pokémon from an Easy Mode run.

---

### **4. Hardcore Replacements**
*(Located in `005_Hardcore_Pokemon_Pool.rb`)*

*   **`pbChooseHardcorePokemon`**
    *   **Description:** Returns the internal symbol (e.g., `:RATTATA`, `:RIOLU`) of a randomly chosen Pokémon based on the weighted `HARDCORE_STARTER_POOL` ratio (90-95% common, 5-10% rare).
    *   **Usage:** Rarely used manually, but available if you want to spawn the specific Pokémon on the overworld before giving it.
*   **`pbGiveHardcoreStarter`**
    *   **Description:** Instantiates a Level 5 Pokémon from the `HARDCORE_STARTER_POOL` and directly adds it to the player's party.
    *   **Usage:** Use this inside the autorun Event that triggers when `RAID_BLACKOUT_SWITCH` is turned ON (e.g., Steven giving you a new starter after your entire PC/Party wipes).

---

### **5. Random Selector Plugins**

*   **`pbChooseRandomPokemon(whiteList=nil, blackList=nil, addList=nil, base_only=true, choose_gen=nil)`**
    *   **Description:** Returns a random Pokémon species based on the provided filters. `whiteList` acts as a base pool, `blackList` excludes species, `addList` forcibly includes species, `base_only` limits it to base forms, and `choose_gen` filters by generation.
    *   **Usage:** `pbChooseRandomPokemon(nil, nil, nil, true, 1)` -> Returns a random base-stage Gen 1 Pokémon.

*   **`pbGiveRandomGeneralItem`**
    *   **Description:** Gives the player a randomly selected general item.

*   **`pbGiveRandomTM`**
    *   **Description:** Gives the player a randomly selected TM.

*   **`pbGiveRandomHM`**
    *   **Description:** Gives the player a randomly selected HM.

*   **`pbGiveRandomTMorHM`**
    *   **Description:** Gives the player a randomly selected TM or HM.

*   **`pbGiveRandomTMorHM([:ITEMNAME])`**
    *   **Description:** Gives a randomly selected TM/HM from a specific pool of items passed in the array.
    *   **Usage:** `pbGiveRandomTMorHM([:TM01, :TM02, :HM01])`

*   **`pbGiveRandomRelic(rarity)`**
    *   **Description:** Gives the player a randomly selected Global Relic. `rarity` defaults to `:UNCOMMON` but can be set to `:RARE`.
    *   **Usage:** Used in custom dynamic chests or boss drops.

*   **`pb3DPrinterEvent`**
    *   **Description:** Opens a loop dialogue where the player can feed random eligible relics from their bag to a 3D Printer to gain a specific printed relic item.
    *   **Usage:** Used as a standalone interactable map event.

*   **`pbSpawnFloorMiningSpots`**
    *   **Description:** Dynamically scans the current map for passable floor tiles adjacent to impassable walls and spawns interactive, invisible mining spots with a sparkle animation. When interacted with, they launch the DPt Mining Minigame.
    *   **Usage:** `pbSpawnFloorMiningSpots(min_spots, max_spots)` inside the teleport/map transfer event when generating or entering a new floor.

*   **`pbArtifactShop`**
    *   **Description:** Opens a custom shop UI loop allowing players to purchase Persistent Artifacts (Fortune Coin, Vitality Root, Wisdom Crystal) in exchange for the Hollowed Souls currency they've mined. Items unlock based on the player's Max Floor Reached (`$game_variables[100]`).
    *   **Usage:** Use this on an NPC in the Hub Island (e.g., a shady merchant).

---

### **6. Extraction Bounties (Quest System)**
*(Located in `010_Bounty_Board.rb` & `Plugins/MQS`)*

*   **`pbBountyBoard`**
    *   **Description:** Opens the Bounty Board UI loop, allowing players to view the Quest log (`pbViewQuests`), accept bounties, and turn them in for rewards. Handles repeatable quests by resetting them upon turn-in, and tiered chains (Apex Predator) by automatically unlocking the next tier.
    *   **Usage:** Use this on a static Board/Sign event in the Hub Island.

*   **`pbViewQuests`** / **`activateQuest(:Quest1)`** / **`completeQuest(:Quest1)`**
    *   **Description:** Standard API functions from the Modern Quest System + UI plugin. Used natively within the bounty scripts to toggle the visual quest interface and progress the states.

### pbInflictStatus
The base engine's `pbInflictStatus` function is used for all custom statuses. It takes the same parameters.

**Signature:** `battler.pbInflictStatus(status_id, status_count = 0, msg = nil, user = nil)`
**Parameters:**
- `status_id` (Symbol): The `:id` of the status to inflict (e.g., `:BLEEDING`, `:BLINDNESS`, `:SHAKEN`).
- `status_count` (Integer): Optional. Number of turns the status should last. Default is 0.
- `msg` (String): Optional. Message to display when inflicted.
- `user` (Battler): Optional. The battler inflicting the status.

**Example usage in a move effect:**
```ruby
if target.pbCanInflictStatus?(:BLEEDING, user, false, self)
  target.pbInflictStatus(:BLEEDING, 0, _INTL("{1} began to bleed!", target.pbThis), user)
end
```
