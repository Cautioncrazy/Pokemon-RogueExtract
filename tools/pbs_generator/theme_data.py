import json
import os
from functools import lru_cache


def _tools_dir():
    return os.path.dirname(__file__)


def _types_enhanced_json_path():
    return os.path.join(_tools_dir(), "types_enhanced.json")


def _pokemon_index_json_path():
    return os.path.join(_tools_dir(), "pokemon_index.json")


def _normalize_species_id(species_id):
    return str(species_id).strip()


@lru_cache(maxsize=1)
def load_types_enhanced_payload():
    path = _types_enhanced_json_path()
    if not os.path.exists(path):
        return None
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


@lru_cache(maxsize=1)
def load_pokemon_index_payload():
    path = _pokemon_index_json_path()
    if not os.path.exists(path):
        return None
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


@lru_cache(maxsize=1)
def get_pokemon_entry_map():
    payload = load_pokemon_index_payload()
    entries = {}
    if not payload:
        return entries
    for p in payload.get("pokemon", []):
        sid = _normalize_species_id(p.get("species_id", ""))
        if sid:
            entries[sid] = p
    return entries


def _is_special_boss_species(entry):
    if not entry:
        return False
    return bool(
        entry.get("legendary")
        or entry.get("mythical")
        or entry.get("ultra_beast")
        or entry.get("paradox")
    )


def _theme_pool_from_types_json(theme):
    payload = load_types_enhanced_payload()
    if not payload:
        return []
    type_groups = payload.get("type_groups", {})
    # Type themes use uppercase key names in JSON (e.g. GRASS, FIRE)
    key = str(theme or "").strip().upper()
    group = type_groups.get(key, [])
    return [_normalize_species_id(p.get("species_id", "")) for p in group if p.get("species_id")]


def _theme_pool_from_special_rules(theme):
    theme_key = str(theme or "").strip().lower()
    entry_map = get_pokemon_entry_map()
    if not entry_map:
        return []

    results = []
    for species_id, entry in entry_map.items():
        if _is_special_boss_species(entry):
            continue
        types = set(entry.get("types") or [])
        bst = int(entry.get("bst") or 0)
        if theme_key == "healing":
            # Supportive/fairy-leaning archetypes plus some normal healers.
            if types.intersection({"FAIRY", "PSYCHIC", "NORMAL"}) and bst <= 620:
                results.append(species_id)
        elif theme_key == "heavy":
            # Bulky/powerful archetypes.
            if bst >= 430 or types.intersection({"ROCK", "STEEL", "GROUND", "FIGHTING"}):
                results.append(species_id)
    return results


def get_species_pool_for_theme(theme, include_special_boss=False):
    """
    Returns a species list for a given theme from JSON payloads.
    Priority:
      1) types_enhanced.json type groups (FIRE/WATER/etc.)
      2) special semantic themes (Healing/Heavy) from pokemon_index.json
    """
    pool = _theme_pool_from_types_json(theme)
    if not pool:
        pool = _theme_pool_from_special_rules(theme)

    if include_special_boss:
        return list(dict.fromkeys(pool))

    entry_map = get_pokemon_entry_map()
    filtered = []
    for species_id in pool:
        entry = entry_map.get(species_id)
        if entry and _is_special_boss_species(entry):
            continue
        filtered.append(species_id)
    return list(dict.fromkeys(filtered))


def get_filter_categories():
    """Returns a list of supported filter categories from the index."""
    return ["None", "bst_tier", "catch_rate_tier", "encounter_rarity", "egg_groups"]


def get_filter_values_for_category(category):
    """Returns the valid sequential or distinct values for a given category."""
    if category == "bst_tier":
        return ["weak", "earlygame", "midgame", "lategame", "ace", "boss"]
    elif category == "catch_rate_tier":
        return ["very_easy", "easy", "normal", "hard", "rare", "legendary"]
    elif category == "encounter_rarity":
        return ["common", "uncommon", "rare", "very_rare", "legendary"]
    elif category == "egg_groups":
        entry_map = get_pokemon_entry_map()
        egg_groups = set()
        for entry in entry_map.values():
            for eg in entry.get("egg_groups", []):
                egg_groups.add(eg)
        return sorted(list(egg_groups))
    return []


def filter_species_pool(pool, category, value):
    """
    Filters a species pool based on a pokemon_index.json category and value.
    If the resulting pool is empty, iterates through the category's fallback tiers.
    If all fallbacks fail, returns the original pool to guarantee spawns.
    """
    if not category or category == "None" or not value:
        return pool

    entry_map = get_pokemon_entry_map()
    if not entry_map:
        return pool

    valid_values = get_filter_values_for_category(category)

    # Locate the starting index for fallbacks
    try:
        start_index = valid_values.index(value)
    except ValueError:
        # If the value isn't in our sequential list (e.g., egg_groups), we can't fall back sequentially.
        # Just try to filter exactly once.
        start_index = -1

    def _attempt_filter(target_val):
        filtered = []
        for species_id in pool:
            entry = entry_map.get(species_id)
            if not entry:
                continue
            entry_val = entry.get(category)
            if isinstance(entry_val, list):
                if target_val in entry_val:
                    filtered.append(species_id)
            elif entry_val == target_val:
                filtered.append(species_id)
        return filtered

    # Attempt exact match first
    result = _attempt_filter(value)
    if result:
        return result

    # If exact match failed and we have sequential fallbacks
    if start_index >= 0:
        for i in range(start_index + 1, len(valid_values)):
            fallback_val = valid_values[i]
            print(f"Filter fallback triggered for '{category}': {valid_values[i-1]} -> {fallback_val}")
            result = _attempt_filter(fallback_val)
            if result:
                return result

    # If all fallbacks failed, return the original pool
    print(f"Warning: Filter '{category}: {value}' exhausted all fallbacks. Returning unfiltered pool.")
    return pool


def get_all_available_themes(md_themes=None):
    themes = []
    if md_themes:
        themes.extend(md_themes)

    payload = load_types_enhanced_payload()
    if payload:
        type_order = payload.get("meta", {}).get("type_order", [])
        themes.extend([str(t).title() for t in type_order])

    # Include semantic themes powered by pokemon_index metadata
    themes.extend(["Healing", "Heavy"])

    deduped = []
    seen = set()
    for theme in themes:
        key = str(theme).strip().lower()
        if not key or key in seen:
            continue
        seen.add(key)
        deduped.append(str(theme).strip())
    return deduped

