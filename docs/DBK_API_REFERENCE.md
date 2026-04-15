# Deluxe Battle Kit (DBK) - Master AI Architecture Reference
**Environment:** Pokémon Essentials v21.1, MKXP-Z, Ruby.

## 1. Boss Encounters (Alpha / Raid)
* **Identification:** Bosses do NOT use vanilla `setBattleRule("wildBoss")`. Check if a battler is a DBK boss using: `@battler.pokemon && (@battler.pokemon.is_boss? || @battler.pokemon.has_immunity?(:RAIDBOSS))`
* **HP Multipliers:** DBK handles massive boss HP pools by multiplying the base HP. Custom UI bars must calculate `hp.to_f / totalhp.to_f` and dynamically slice visuals (e.g., EBUI `blt` logic).
* **Boss Shields:** Bosses can have segmented shields. Check `battler.shieldCount` or DBK's internal shield array if rendering armor UI.

## 2. Advanced Combat Mechanics (Triggers & Hooks)
When writing scripts that check if a Pokémon is using a special DBK mechanic, use these native object checks:
* **Mega Evolution:** `battler.mega?`
* **Primal Reversion:** `battler.primal?`
* **Z-Moves:** `battler.usingZMove?` or check if the selected move `is_zmove?`
* **Dynamax/Gigantamax:** `battler.dynamax?` / `battler.gmax?`. Dynamax HP scaling is handled internally; UI elements should scale sprite `zoom_x` and `zoom_y` by DBK's Dynamax constants.
* **Terastallization:** `battler.tera?`. Check the Tera type via `battler.tera_type`.

## 3. Mid-Battle Scripting (Phase Transitions)
Do not hardcode event checks into `update` loops. Use DBK's native Mid-Battle hooks to trigger dialogue, stat changes, or form shifts during combat.
* **Hook Method:** `pbMidBattleScript`
* **Execution:** These triggers are defined via hashes evaluating conditions like `hp_threshold` (e.g., `battler.hp <= battler.totalhp * 0.5`), `turn_count`, or `on_faint`.

## 4. DBK Visual & UI Extensibility (Alias Targets)
To extend DBK visually without overwriting core engine files, strictly alias these classes:
* **Sprite Modifications (Auras, Scaling, Overlays):** Alias `Battle::Scene::BattlerSprite` (Target methods: `update`, `setPokemonBitmap`, `dispose`).
* **UI & Databoxes (Icons, Custom HP Bars):** Alias `Battle::Scene::PokemonDataBox` and `Battle::Scene::BossDataBox`. For aggressive syncing (like multi-tier boss bars), hook `update`, `refresh_hp`, `animateHP`, `opacity=`, and `visible=`.
* **Slide-In Masking Workarounds:** DBK battle UI elements "slide in" at the start of an encounter using viewport masks. Standalone custom sprites injected into a DataBox will ignore this mask and flash on screen early. To prevent this, use a **Delayed Creation Timer** inside the `update` loop (e.g., waiting 1200 ticks) before instantiating the sprite.
* **Animations:** DBK handles custom animations (like Terastallizing) via `Battle::Scene::Animation`. Do not bypass the animation queue.

## 5. Standard Battle Rules
When calling battles via script (`WildBattle.start`), only use standard v21.1 rules unless explicitly injecting a DBK parameter hash.
* Prevent escaping: `setBattleRule("cannotRun")`