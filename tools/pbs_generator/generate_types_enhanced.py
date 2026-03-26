import json
import re
from pathlib import Path
from collections import defaultdict

# ============================================================
# CONFIG
# ============================================================

PBS_FILENAME = "pokemon.txt"
OUTPUT_MD = "types_enhanced.md"
OUTPUT_JSON = "types_enhanced.json"

TYPE_ORDER = [
    "NORMAL", "FIRE", "WATER", "ELECTRIC", "GRASS", "ICE",
    "FIGHTING", "POISON", "GROUND", "FLYING", "PSYCHIC", "BUG",
    "ROCK", "GHOST", "DRAGON", "DARK", "STEEL", "FAIRY"
]

# Canonical species that have regional variants/forms in official Pokémon.
# This is useful for AI tooling even if your PBS doesn't define those forms as separate species.
REGIONAL_FORM_CAPABLE = {
    # Alolan / Galarian / Hisuian / Paldean lines and notable form-capable species
    "RATTATA", "RATICATE", "RAICHU", "SANDSHREW", "SANDSLASH", "VULPIX", "NINETALES",
    "DIGLETT", "DUGTRIO", "MEOWTH", "PERSIAN", "GEODUDE", "GRAVELER", "GOLEM",
    "GRIMER", "MUK", "EXEGGUTOR", "MAROWAK",

    "PONYTA", "RAPIDASH", "SLOWPOKE", "SLOWBRO", "SLOWKING", "FARFETCHD", "WEEZING",
    "MRMIME", "ARTICUNO", "ZAPDOS", "MOLTRES", "CORSOLA", "ZIGZAGOON", "LINOONE",
    "DARUMAKA", "DARMANITAN", "YAMASK", "STUNFISK",

    "GROWLITHE", "ARCANINE", "VOLTORB", "ELECTRODE", "TYPHLOSION", "QWILFISH",
    "SNEASEL", "SAMUROTT", "LILLIGANT", "ZORUA", "ZOROARK", "BRAVIARY",
    "SLIGGOO", "GOODRA", "AVALUGG", "DECIDUEYE",

    "TAUROS", "WOOPER",

    # Paldean convergents / special edge cases that are often useful to flag
    # (Not true "regional forms" but often useful for AI generation)
    # Uncomment if you want them treated similarly:
    # "DIGLETT", "DUGTRIO", "TENTACOOL", "TENTACRUEL"
}

# Some species are better treated as "special-form-capable" even if not in official regional form buckets.
# Keeping this separate in case you want to extend later.
SPECIAL_FORM_CAPABLE = {
    "DEERLING", "SAWSBUCK", "ORICORIO", "LYCANROC", "WISHIWASHI", "MINIOR",
    "MIMIKYU", "MORPEKO", "SQUAWKABILLY", "TATSUGIRI", "BURMY", "WORMADAM",
    "SHELLOS", "GASTRODON", "BASCULIN", "BASCULEGION", "FLABEBE", "FLOETTE",
    "FLORGES", "PUMPKABOO", "GOURGEIST", "SINISTCHA", "POLTCHAGEIST",
    "ROTOM", "CASTFORM", "CHERRIM", "DARMANITAN", "MELOETTA", "AEGISLASH",
    "XERNEAS", "ZYGARDE", "HOOPA", "SHAYMIN", "GIRATINA", "TORNADUS",
    "THUNDURUS", "LANDORUS", "ENAMORUS"
}

# Type-driven biome hints
TYPE_BIOME_MAP = {
    "NORMAL": {"grassland", "plains"},
    "FIRE": {"volcanic", "mountain", "badlands", "desert"},
    "WATER": {"ocean", "river", "lake", "shore", "wetland"},
    "ELECTRIC": {"powerplant", "stormfield", "urban"},
    "GRASS": {"forest", "meadow", "grassland", "jungle"},
    "ICE": {"snow", "tundra", "glacier", "mountain"},
    "FIGHTING": {"mountain", "dojo", "highland"},
    "POISON": {"swamp", "bog", "toxic", "haunted"},
    "GROUND": {"desert", "cave", "badlands", "plains"},
    "FLYING": {"sky", "cliff", "mountain", "forest"},
    "PSYCHIC": {"ruins", "mystic", "urban"},
    "BUG": {"forest", "meadow", "jungle"},
    "ROCK": {"cave", "mountain", "cliff", "badlands"},
    "GHOST": {"haunted", "graveyard", "ruins", "foglands"},
    "DRAGON": {"mountain", "highland", "ruins", "sanctuary"},
    "DARK": {"cave", "nightforest", "urban", "badlands"},
    "STEEL": {"cave", "urban", "factory", "mountain"},
    "FAIRY": {"fairygrove", "flowerfield", "forest", "mystic"},
}

# Habitat normalization -> biome tags
HABITAT_BIOME_MAP = {
    "Grassland": {"grassland", "meadow", "plains"},
    "Forest": {"forest", "woodland"},
    "WatersEdge": {"shore", "riverbank", "wetland"},
    "Sea": {"ocean", "reef", "shore"},
    "Cave": {"cave", "underground"},
    "Mountain": {"mountain", "cliff", "highland"},
    "RoughTerrain": {"badlands", "rocky", "desert"},
    "Urban": {"urban", "city", "industrial"},
    "Rare": {"rare", "special"},
}

# Extra manual biome overrides for iconic lines / obvious habitat corrections
MANUAL_BIOME_OVERRIDES = {
    "MAGIKARP": {"river", "lake", "pond"},
    "GYARADOS": {"ocean", "lake", "stormwater"},
    "DRATINI": {"lake", "river", "sanctuary"},
    "DRAGONAIR": {"lake", "river", "sanctuary"},
    "DRAGONITE": {"ocean", "cliff", "highland"},
    "ZUBAT": {"cave", "underground"},
    "GOLBAT": {"cave", "underground"},
    "CROBAT": {"cave", "underground"},
    "DIGLETT": {"cave", "underground", "badlands"},
    "DUGTRIO": {"cave", "underground", "badlands"},
    "ONIX": {"cave", "mountain", "underground"},
    "STEELIX": {"cave", "mountain", "underground"},
    "GEODUDE": {"cave", "mountain"},
    "GRAVELER": {"cave", "mountain"},
    "GOLEM": {"cave", "mountain"},
    "LAPRAS": {"ocean", "shore", "icewater"},
    "SNORLAX": {"forest", "mountain", "plains"},
    "ABRA": {"urban", "grassland", "mystic"},
    "KADABRA": {"urban", "grassland", "mystic"},
    "ALAKAZAM": {"urban", "mystic", "ruins"},
}

# ============================================================
# PARSE PBS
# ============================================================

def parse_pokemon_pbs(file_path: Path):
    text = file_path.read_text(encoding="utf-8", errors="ignore")

    # Split by [SPECIES] section headers
    parts = re.split(r"(?m)^\[(.+?)\]\s*$", text)

    species_entries = []
    # parts = [preamble, section_name1, body1, section_name2, body2, ...]
    for i in range(1, len(parts), 2):
        species_id = parts[i].strip()
        body = parts[i + 1]

        data = {}
        for raw_line in body.splitlines():
            line = raw_line.strip()
            if not line or line.startswith("#"):
                continue
            if "=" in line:
                key, value = line.split("=", 1)
                data[key.strip()] = value.strip()

        if species_id:
            species_entries.append((species_id, data))

    return species_entries

# ============================================================
# HELPERS
# ============================================================

def parse_types(type_str: str):
    if not type_str:
        return []
    return [t.strip().upper() for t in type_str.split(",") if t.strip()]

def parse_flags(flag_str: str):
    if not flag_str:
        return []
    return [f.strip() for f in flag_str.split(",") if f.strip()]

def detect_legendary_mythical(flags, species_id, generation):
    """
    Priority:
    1) Use PBS flags if present
    2) Fallback to a curated canonical list
    """
    lower_flags = {f.lower() for f in flags}

    # PBS-based detection
    if any("mythical" in f for f in lower_flags):
        return True, True
    if any("legendary" in f for f in lower_flags):
        return True, False
    if any("sublegendary" in f for f in lower_flags):
        return True, False

    # Canonical fallback
    mythical_set = {
        "MEW", "CELEBI", "JIRACHI", "DEOXYS", "PHIONE", "MANAPHY", "DARKRAI", "SHAYMIN",
        "ARCEUS", "VICTINI", "KELDEO", "MELOETTA", "GENESECT", "DIANCIE", "HOOPA",
        "VOLCANION", "MAGEARNA", "MARSHADOW", "ZERAORA", "MELTAN", "MELMETAL",
        "ZARUDE", "PECHARUNT"
    }

    legendary_set = {
        "ARTICUNO", "ZAPDOS", "MOLTRES", "MEWTWO",
        "RAIKOU", "ENTEI", "SUICUNE", "LUGIA", "HOOH",
        "REGIROCK", "REGICE", "REGISTEEL", "LATIAS", "LATIOS", "KYOGRE", "GROUDON",
        "RAYQUAZA", "UXIE", "MESPRIT", "AZELF", "DIALGA", "PALKIA", "HEATRAN",
        "REGIGIGAS", "GIRATINA", "CRESSELIA",
        "COBALION", "TERRAKION", "VIRIZION", "TORNADUS", "THUNDURUS", "RESHIRAM",
        "ZEKROM", "LANDORUS", "KYUREM",
        "XERNEAS", "YVELTAL", "ZYGARDE",
        "TYPE_NULL", "SILVALLY", "TAPU KOKO", "TAPU LELE", "TAPU BULU", "TAPU FINI",
        "COSMOG", "COSMOEM", "SOLGALEO", "LUNALA", "NECROZMA",
        "NIHILEGO", "BUZZWOLE", "PHEROMOSA", "XURKITREE", "CELESTEELA", "KARTANA",
        "GUZZLORD", "POIPOLE", "NAGANADEL", "STAKATAKA", "BLACEPHALON",
        "KUBFU", "URSHIFU", "REGIELEKI", "REGIDRAGO", "GLASTRIER", "SPECTRIER",
        "CALYREX", "ZACIAN", "ZAMAZENTA", "ETERNATUS",
        "WOCHIEN", "CHIENPAO", "TINGLU", "CHIYU", "KORAIDON", "MIRAIDON",
        "OKIDOGI", "MUNKIDORI", "FEZANDIPITI", "OGERPON", "TERAPAGOS"
    }

    normalized = species_id.replace("_", " ")

    if species_id in mythical_set or normalized in mythical_set:
        return True, True
    if species_id in legendary_set or normalized in legendary_set:
        return True, False

    return False, False

def infer_biomes(species_id, types, habitat):
    biomes = set()

    # Habitat first
    if habitat in HABITAT_BIOME_MAP:
        biomes |= HABITAT_BIOME_MAP[habitat]

    # Type heuristics
    for t in types:
        biomes |= TYPE_BIOME_MAP.get(t, set())

    # Manual overrides
    if species_id in MANUAL_BIOME_OVERRIDES:
        biomes |= MANUAL_BIOME_OVERRIDES[species_id]

    # Some cleanup rules
    if "ocean" in biomes and "shore" not in biomes:
        biomes.add("shore")
    if "mountain" in biomes and "cliff" not in biomes:
        biomes.add("cliff")
    if "forest" in biomes and "woodland" not in biomes:
        biomes.add("woodland")

    # Cap size for cleaner AI output while keeping variety
    # Priority-ish sort by a useful order
    preferred_order = [
        "forest", "woodland", "jungle", "meadow", "grassland", "plains",
        "cave", "underground", "mountain", "cliff", "highland",
        "ocean", "shore", "reef", "river", "riverbank", "lake", "pond", "wetland",
        "swamp", "bog", "desert", "badlands", "rocky", "volcanic",
        "snow", "tundra", "glacier", "icewater",
        "haunted", "graveyard", "ruins", "mystic", "sanctuary",
        "urban", "city", "industrial", "factory", "powerplant",
        "stormfield", "nightforest", "fairygrove", "flowerfield", "toxic",
        "rare", "special"
    ]

    ordered = [b for b in preferred_order if b in biomes]
    extras = sorted(b for b in biomes if b not in preferred_order)
    result = ordered + extras

    # Keep it useful but not absurdly long
    return result[:8]

def format_bool_flag(value, true_text, false_text):
    return true_text if value else false_text

# ============================================================
# BUILD DATA
# ============================================================

def build_enhanced_index(species_entries):
    pokemon = []
    type_groups = defaultdict(list)

    for dex_num, (species_id, data) in enumerate(species_entries, start=1):
        name = data.get("Name", species_id.title())
        types = parse_types(data.get("Types", ""))
        habitat = data.get("Habitat", "")
        flags = parse_flags(data.get("Flags", ""))
        generation = data.get("Generation", "")

        regional_form_capable = (
            species_id in REGIONAL_FORM_CAPABLE
            or species_id in SPECIAL_FORM_CAPABLE
        )

        legendary, mythical = detect_legendary_mythical(flags, species_id, generation)
        biome_tags = infer_biomes(species_id, types, habitat)

        entry = {
            "national_dex": dex_num,
            "species_id": species_id,
            "name": name,
            "types": types,
            "habitat": habitat if habitat else None,
            "biome_tags": biome_tags,
            "regional_form_capable": regional_form_capable,
            "legendary": legendary,
            "mythical": mythical,
            "flags": flags
        }

        pokemon.append(entry)

        for t in types:
            type_groups[t].append(entry)

    # Ensure all types exist in output even if empty
    for t in TYPE_ORDER:
        type_groups.setdefault(t, [])

    return pokemon, type_groups

# ============================================================
# WRITE MARKDOWN
# ============================================================

def write_markdown(path: Path, pokemon, type_groups):
    lines = []

    # Required directive from user
    lines.append("# Pokémon Type Master Reference (Enhanced)")
    lines.append("")
    lines.append("AI ASSISTANT DIRECTIVE (JULES):")
    lines.append("This document serves as the master reference for Pokémon type classifications. When building themed trainer parties, designing biome-specific encounter tables, or generating typed loot, use these lists to select appropriate Pokémon.")
    lines.append("")
    lines.append("Note for Dual Types: Pokémon with two types are listed under BOTH of their respective type categories. Always cross-reference with the master pokemon.txt PBS file if a newly added regional variant or custom Pokémon is not explicitly listed here.")
    lines.append("")
    lines.append("---")
    lines.append("")
    lines.append("## Metadata Key")
    lines.append("")
    lines.append("- **Format:** `DEX | SPECIES_ID | Display Name | [Type1/Type2] | RegionalCapable | Classification | Biomes`")
    lines.append("- **RegionalCapable:** `RegionalCapable` or `NoRegionalFlag`")
    lines.append("- **Classification:** `Mythical`, `Legendary`, or `Standard`")
    lines.append("- **Biomes:** AI-friendly environment tags inferred from `Habitat` + type heuristics + manual overrides")
    lines.append("")
    lines.append(f"- **Total Pokémon indexed:** {len(pokemon)}")
    lines.append("")

    for t in TYPE_ORDER:
        group = sorted(type_groups[t], key=lambda x: (x["national_dex"], x["species_id"]))

        lines.append(f"## {t.title()} Type")
        lines.append("")

        if not group:
            lines.append("_No Pokémon found in this type group._")
            lines.append("")
            continue

        for p in group:
            dex_str = str(p["national_dex"]).zfill(4)
            type_label = "/".join(p["types"]) if p["types"] else "UNKNOWN"
            regional_text = format_bool_flag(p["regional_form_capable"], "RegionalCapable", "NoRegionalFlag")

            if p["mythical"]:
                classification = "Mythical"
            elif p["legendary"]:
                classification = "Legendary"
            else:
                classification = "Standard"

            biomes = ", ".join(p["biome_tags"]) if p["biome_tags"] else "none"

            lines.append(
                f"- `{dex_str} | {p['species_id']} | {p['name']} | [{type_label}] | {regional_text} | {classification} | {biomes}`"
            )

        lines.append("")

    path.write_text("\n".join(lines), encoding="utf-8")

# ============================================================
# WRITE JSON
# ============================================================

def write_json(path: Path, pokemon, type_groups):
    payload = {
        "meta": {
            "title": "Pokemon Type Master Reference (Enhanced)",
            "description": (
                "AI-friendly master reference for Pokémon type classifications. "
                "Dual-types are listed under both type groups. Includes National Dex numbers, "
                "regional form flags, legendary/mythical tagging, and biome tags."
            ),
            "ai_assistant_directive": {
                "agent": "JULES",
                "text": (
                    "This document serves as the master reference for Pokémon type classifications. "
                    "When building themed trainer parties, designing biome-specific encounter tables, "
                    "or generating typed loot, use these lists to select appropriate Pokémon."
                ),
                "dual_type_note": (
                    "Pokémon with two types are listed under BOTH of their respective type categories. "
                    "Always cross-reference with the master pokemon.txt PBS file if a newly added regional "
                    "variant or custom Pokémon is not explicitly listed here."
                )
            },
            "type_order": TYPE_ORDER,
            "total_pokemon_indexed": len(pokemon)
        },
        "type_groups": {},
        "pokemon": pokemon
    }

    for t in TYPE_ORDER:
        payload["type_groups"][t] = [
            {
                "national_dex": p["national_dex"],
                "species_id": p["species_id"],
                "name": p["name"],
                "types": p["types"],
                "habitat": p["habitat"],
                "biome_tags": p["biome_tags"],
                "regional_form_capable": p["regional_form_capable"],
                "legendary": p["legendary"],
                "mythical": p["mythical"],
                "flags": p["flags"]
            }
            for p in sorted(type_groups[t], key=lambda x: (x["national_dex"], x["species_id"]))
        ]

    path.write_text(json.dumps(payload, indent=2, ensure_ascii=False), encoding="utf-8")

# ============================================================
# MAIN
# ============================================================

def main():
    script_dir = Path(__file__).resolve().parent
    repo_root = script_dir.parent.parent
    pbs_dir = repo_root / "PBS"
    pbs_path = pbs_dir / PBS_FILENAME

    if not pbs_path.exists():
        raise FileNotFoundError(
            f"Could not find '{PBS_FILENAME}' in expected PBS folder:\n"
            f"  {pbs_path}\n"
            f"Make sure this repository has a 'PBS' directory with pokemon.txt."
        )

    species_entries = parse_pokemon_pbs(pbs_path)
    if not species_entries:
        raise ValueError("No Pokémon species entries were found in pokemon.txt.")

    pokemon, type_groups = build_enhanced_index(species_entries)

    output_md_path = script_dir / OUTPUT_MD
    output_json_path = script_dir / OUTPUT_JSON
    write_markdown(output_md_path, pokemon, type_groups)
    write_json(output_json_path, pokemon, type_groups)

    print(f"Done! Generated:")
    print(f"  - {output_md_path}")
    print(f"  - {output_json_path}")
    print(f"Indexed Pokémon: {len(pokemon)}")

if __name__ == "__main__":
    main()