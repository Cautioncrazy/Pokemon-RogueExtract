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
    return str(species_id).strip().upper()


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

