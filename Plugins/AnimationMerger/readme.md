# Custom Animation Merger

This tool allows you to safely merge custom battle animations (`PkmnAnimations.rxdata`) from various plugin packs into your main Pokémon Essentials v21.1 project.

Because the Pokémon Essentials Animation Editor natively saves the entire array of animations (even ones the plugin author didn't change), directly replacing your `PkmnAnimations.rxdata` with a downloaded plugin pack often overwrites your pristine v21.1 vanilla animations with broken, outdated, or blank v20 padding.

This Merger solves that issue by deeply inspecting the arrays and offering several merge strategies to protect your vanilla animations.

## How to Use

1. Place downloaded plugin animation packs inside their own folders within `Plugins/` (e.g. `Plugins/Gen3Moves/PkmnAnimations.rxdata`).
2. Open your game in Debug mode.
3. Open the Debug Menu -> **Other editors** -> **Animation Merger**.
4. The tool will automatically scan the `Plugins/` directory and prompt you to establish priority ranks.

## Merge Modes

When merging, the tool actively ignores completely blank "padding" animations (animations missing both cel frames and timing sound/image effects) saved by plugin authors. For valid duplicate animations (where the plugin pack and your base project share the same name, e.g. `Move:BITE`), you will be prompted to choose a merge mode:

*   **Append Only (Skip existing):**
    Safely ignores all duplicate animations and only appends genuinely new ones to the end of your list.
*   **Smart Overwrite (Has custom graphic):**
    Only overwrites an existing base animation if the plugin's version explicitly utilizes a custom external graphic sheet. This mode safely merges custom moves (like Bite or Flamethrower) while actively protecting your vanilla weather/field moves (like `Common:Rain`) from being wiped out by broken v20 cel-less variants.
*   **Overwrite All (Replace existing):**
    Blindly overwrites your base animations with the plugin's versions if their names match. Use with caution.
*   **Interactive (Select overwrites):**
    Pre-scans the collision list and presents an interactive menu (`[ ]` / `[X]`). You can manually toggle exactly which vanilla animations you want replaced by the plugin.

## Recommended Workflow

Some perfectly valid custom animations (like Gen 3 status conditions such as `Common:Poison` or `Common:Paralysis`) simulate visual effects natively via screen/sprite tone modifications rather than utilizing custom graphic sheets. As a result, **Smart Overwrite** will intentionally skip them.

For the best results when installing a new animation pack:

1.  Run the **Animation Merger** and select **Smart Overwrite**. This performs a safe mass-merge, pulling in all the major custom graphic moves while automatically blocking broken padding.
2.  Run the **Animation Merger** a second time and select **Interactive (Select overwrites)**. Scroll through the list and surgically check `[X]` on specific animations that `Smart Overwrite` skipped, such as `Common:Poison` or stat modifications, to safely extract them.

*(Note: The merger clears the runtime cache immediately upon completion, so your merged animations will be fully testable without needing to reboot the engine).*