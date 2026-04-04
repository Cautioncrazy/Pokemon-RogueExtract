## Custom Status UI Icons: Instructions

To ensure your custom statuses display the correct icons in the UI (both in the party screen and during battles), you only need to modify the status image sprite sheets.

Based on the graphics you provided (`statuses.png` and `icon_statuses.png`), the game engine has been explicitly updated to map the UI graphics to specific positions so you can freely add your custom statuses to the bottom of the list.

### Current Sprite Sheet Mapping (Based on your provided graphics):

**`Graphics/UI/statuses.png` (Party & Summary Screens)**
- Position 0: `SLP` (Sleep)
- Position 1: `PSN` (Poison)
- Position 2: `BRN` (Burn)
- Position 3: `PAR` (Paralysis)
- Position 4: `FRZ` (Frozen)
- Position 5: `FNT` (Fainted) - *The engine is now hardcoded to look for Faint at position 5*
- Position 6: `PKRS` (Pokérus) - *The engine is now hardcoded to look for Pokérus at position 6*
- Position 7: `BLD` (Bleeding)
- Position 8+: Insert future custom statuses here (e.g., Blindness = 8, Shaken = 9).

**`Graphics/UI/Battle/icon_statuses.png` (Battle Screen)**
- Position 0: `SLP` (Sleep)
- Position 1: `PSN` (Poison)
- Position 2: `BRN` (Burn)
- Position 3: `PAR` (Paralysis)
- Position 4: `FRZ` (Frozen)
- Position 5: `PSN` (Badly Poisoned / Toxic) - *The engine is now hardcoded to look for Bad Poison at position 5*
- Position 6: `BLD` (Bleeding)
- Position 7+: Insert future custom statuses here (e.g., Blindness = 7, Shaken = 8).

### Important Action Needed:
Since the user's provided `icon_statuses.png` graphic only has Bleed at position 6, and `statuses.png` has it at position 7, **you must ensure `010_Status.rb` has the correct `:icon_position` set.**

For now, the code relies on the position mappings defined in `010_Status.rb`. When you update the graphics for `Blindness` and `Shaken`, be sure to add them to the *bottom* of both graphics and update their respective `:icon_position` integers in `Data/Scripts/010_Data/001_Hardcoded data/010_Status.rb` to match their exact slot number on the sheet (starting from 0 at the top).
