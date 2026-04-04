import json
import re
from pathlib import Path
from collections import defaultdict, deque

# ============================================================
# CONFIG
# ============================================================

PBS_FILENAME = "pokemon.txt"
OUTPUT_MD = "pokemon_index.md"
OUTPUT_JSON = "pokemon_index.json"

TYPE_ORDER = [
    "NORMAL", "FIRE", "WATER", "ELECTRIC", "GRASS", "ICE",
    "FIGHTING", "POISON", "GROUND", "FLYING", "PSYCHIC", "BUG",
    "ROCK", "GHOST", "DRAGON", "DARK", "STEEL", "FAIRY"
]

# ============================================================
# KNOWN TAG SETS / CURATED LISTS
# ============================================================

STARTERS = {
    "BULBASAUR", "CHARMANDER", "SQUIRTLE",
    "CHIKORITA", "CYNDAQUIL", "TOTODILE",
    "TREECKO", "TORCHIC", "MUDKIP",
    "TURTWIG", "CHIMCHAR", "PIPLUP",
    "SNIVY", "TEPIG", "OSHAWOTT",
    "CHESPIN", "FENNEKIN", "FROAKIE",
    "ROWLET", "LITTEN", "POPPLIO",
    "GROOKEY", "SCORBUNNY", "SOBBLE",
    "SPRIGATITO", "FUECOCO", "QUAXLY"
}

FOSSILS = {
    "OMANYTE", "OMASTAR", "KABUTO", "KABUTOPS", "AERODACTYL",
    "LILEEP", "CRADILY", "ANORITH", "ARMALDO",
    "CRANIDOS", "RAMPARDOS", "SHIELDON", "BASTIODON",
    "TIRTOUGA", "CARRACOSTA", "ARCHEN", "ARCHEOPS",
    "TYRUNT", "TYRANTRUM", "AMAURA", "AURORUS",
    "DRACOZOLT", "ARCTOZOLT", "DRACOVISH", "ARCTOVISH"
}

PSEUDO_LEGENDARIES = {
    "DRATINI", "DRAGONAIR", "DRAGONITE",
    "LARVITAR", "PUPITAR", "TYRANITAR",
    "BAGON", "SHELGON", "SALAMENCE",
    "BELDUM", "METANG", "METAGROSS",
    "GIBLE", "GABITE", "GARCHOMP",
    "DEINO", "ZWEILOUS", "HYDREIGON",
    "GOOMY", "SLIGGOO", "GOODRA",
    "JANGMOO", "HAKAMOO", "KOMMOO",
    "DREEPY", "DRAKLOAK", "DRAGAPULT",
    "FRIGIBAX", "ARCTIBAX", "BAXCALIBUR"
}

ULTRA_BEASTS = {
    "NIHILEGO", "BUZZWOLE", "PHEROMOSA", "XURKITREE", "CELESTEELA",
    "KARTANA", "GUZZLORD", "POIPOLE", "NAGANADEL", "STAKATAKA", "BLACEPHALON"
}

PARADOX_NAMES = {
    # Scarlet / Violet Paradox Pokémon
    "GREAT TUSK", "SCREAM TAIL", "BRUTE BONNET", "FLUTTER MANE",
    "SLITHER WING", "SANDY SHOCKS", "ROARING MOON", "KORAIDON",
    "IRON TREADS", "IRON BUNDLE", "IRON HANDS", "IRON JUGULIS",
    "IRON MOTH", "IRON THORNS", "IRON VALIANT", "MIRAIDON",
    "WALKING WAKE", "IRON LEAVES", "GOUGING FIRE", "RAGING BOLT",
    "IRON BOULDER", "IRON CROWN"
}

REGIONAL_FORM_CAPABLE = {
    "RATTATA", "RATICATE", "RAICHU", "SANDSHREW", "SANDSLASH", "VULPIX", "NINETALES",
    "DIGLETT", "DUGTRIO", "MEOWTH", "PERSIAN", "GEODUDE", "GRAVELER", "GOLEM",
    "GRIMER", "MUK", "EXEGGUTOR", "MAROWAK",
    "PONYTA", "RAPIDASH", "SLOWPOKE", "SLOWBRO", "SLOWKING", "FARFETCHD", "WEEZING",
    "MRMIME", "ARTICUNO", "ZAPDOS", "MOLTRES", "CORSOLA", "ZIGZAGOON", "LINOONE",
    "DARUMAKA", "DARMANITAN", "YAMASK", "STUNFISK",
    "GROWLITHE", "ARCANINE", "VOLTORB", "ELECTRODE", "TYPHLOSION", "QWILFISH",
    "SNEASEL", "SAMUROTT", "LILLIGANT", "ZORUA", "ZOROARK", "BRAVIARY",
    "SLIGGOO", "GOODRA", "AVALUGG", "DECIDUEYE",
    "TAUROS", "WOOPER"
}

SPECIAL_FORM_CAPABLE = {
    "DEERLING", "SAWSBUCK", "ORICORIO", "LYCANROC", "WISHIWASHI", "MINIOR",
    "MIMIKYU", "MORPEKO", "SQUAWKABILLY", "TATSUGIRI", "BURMY", "WORMADAM",
    "SHELLOS", "GASTRODON", "BASCULIN", "BASCULEGION", "FLABEBE", "FLOETTE",
    "FLORGES", "PUMPKABOO", "GOURGEIST", "ROTOM", "CASTFORM", "CHERRIM",
    "MELOETTA", "AEGISLASH", "XERNEAS", "ZYGARDE", "HOOPA", "SHAYMIN", "GIRATINA",
    "TORNADUS", "THUNDURUS", "LANDORUS", "ENAMORUS"
}

MYTHICAL_SET = {
    "MEW", "CELEBI", "JIRACHI", "DEOXYS", "PHIONE", "MANAPHY", "DARKRAI", "SHAYMIN",
    "ARCEUS", "VICTINI", "KELDEO", "MELOETTA", "GENESECT", "DIANCIE", "HOOPA",
    "VOLCANION", "MAGEARNA", "MARSHADOW", "ZERAORA", "MELTAN", "MELMETAL",
    "ZARUDE", "PECHARUNT"
}

LEGENDARY_SET = {
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

# ============================================================
# PARSING
# ============================================================

def parse_pokemon_pbs(file_path: Path):
    text = file_path.read_text(encoding="utf-8", errors="ignore")
    parts = re.split(r"(?m)^\[(.+?)\]\s*$", text)

    species_entries = []
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

def parse_csv_field(value):
    if not value:
        return []
    return [x.strip() for x in value.split(",") if x.strip()]

def parse_types(type_str):
    return [x.strip().upper() for x in parse_csv_field(type_str)]

def parse_int(value, default=0):
    try:
        return int(str(value).strip())
    except:
        return default

def parse_base_stats(stats_str):
    vals = [parse_int(x, 0) for x in parse_csv_field(stats_str)]
    # Expected usually 6 values in Essentials
    if len(vals) < 6:
        vals += [0] * (6 - len(vals))
    return vals[:6]

def normalize_species_key(species_id):
    return species_id.strip()

def display_species_key(species_id):
    return species_id.replace("_", " ")

# ============================================================
# FLAG / CATEGORY DETECTION
# ============================================================

def detect_legendary_mythical(species_id, flags):
    lower_flags = {f.lower() for f in flags}
    species_display = display_species_key(species_id)

    if any("mythical" in f for f in lower_flags):
        return True, True
    if any("legendary" in f for f in lower_flags):
        return True, False
    if any("sublegendary" in f for f in lower_flags):
        return True, False

    if species_id in MYTHICAL_SET or species_display in MYTHICAL_SET:
        return True, True
    if species_id in LEGENDARY_SET or species_display in LEGENDARY_SET:
        return True, False

    return False, False

def detect_ultra_beast(species_id, flags):
    lower_flags = {f.lower() for f in flags}
    if any("ultrabeast" in f or "ultra beast" in f for f in lower_flags):
        return True
    return species_id in ULTRA_BEASTS or display_species_key(species_id) in ULTRA_BEASTS

def detect_paradox(species_id, name, flags):
    lower_flags = {f.lower() for f in flags}
    if any("paradox" in f for f in lower_flags):
        return True

    upper_name = (name or "").strip().upper()
    upper_species_display = display_species_key(species_id)

    if upper_name in PARADOX_NAMES or upper_species_display in PARADOX_NAMES:
        return True
    if upper_name.startswith("IRON ") or upper_species_display.startswith("IRON "):
        return True

    return False

def detect_fossil(species_id, flags):
    lower_flags = {f.lower() for f in flags}
    if any("fossil" in f for f in lower_flags):
        return True
    return species_id in FOSSILS

def detect_starter(species_id, flags):
    lower_flags = {f.lower() for f in flags}
    if any("starter" in f for f in lower_flags):
        return True
    return species_id in STARTERS

# ============================================================
# EVOLUTION PARSING
# ============================================================

def parse_evolutions(evo_str):
    """
    Essentials commonly uses:
    Evolutions=SPECIES,Method,Parameter,SPECIES2,Method2,Parameter2,...
    We only care about target species IDs at every 3-step interval.
    """
    tokens = parse_csv_field(evo_str)
    results = []

    i = 0
    while i < len(tokens):
        target = tokens[i].strip()
        method = tokens[i + 1].strip() if i + 1 < len(tokens) else None
        param = tokens[i + 2].strip() if i + 2 < len(tokens) else None

        if target:
            results.append({
                "target": target,
                "method": method,
                "parameter": param
            })
        i += 3

    return results

# ============================================================
# TIERS / AI TAGS
# ============================================================

def bst_tier(bst, legendary=False, mythical=False, ultra_beast=False, paradox=False):
    if mythical or legendary or ultra_beast or paradox:
        return "boss"
    if bst >= 600:
        return "boss"
    if bst >= 540:
        return "ace"
    if bst >= 460:
        return "lategame"
    if bst >= 360:
        return "midgame"
    if bst >= 260:
        return "earlygame"
    return "weak"

def catch_rate_tier(catch_rate, legendary=False, mythical=False):
    if legendary or mythical:
        return "legendary"
    if catch_rate >= 200:
        return "very_easy"
    if catch_rate >= 120:
        return "easy"
    if catch_rate >= 60:
        return "normal"
    if catch_rate >= 25:
        return "hard"
    return "rare"

def encounter_rarity_tag(catch_rate, legendary=False, mythical=False, ultra_beast=False, paradox=False):
    if legendary or mythical or ultra_beast or paradox:
        return "legendary"
    if catch_rate >= 190:
        return "common"
    if catch_rate >= 100:
        return "uncommon"
    if catch_rate >= 45:
        return "rare"
    return "very_rare"

def trainer_suitability_tags(entry):
    tags = []

    if entry["mythical"] or entry["legendary"] or entry["ultra_beast"] or entry["paradox"]:
        return ["boss", "champion"]

    tier = entry["bst_tier"]

    if tier in {"weak", "earlygame"}:
        tags.append("earlygame")
    if tier in {"midgame"}:
        tags.append("midgame")
    if tier in {"lategame"}:
        tags.extend(["midgame", "lategame"])
    if tier == "ace":
        tags.extend(["lategame", "gym_ace", "elite_four"])
    if tier == "boss":
        tags.extend(["gym_ace", "elite_four", "champion", "boss"])

    if entry["starter"]:
        tags.extend(["gym_ace", "lategame"])

    if entry["pseudo_legendary"]:
        tags.extend(["elite_four", "champion", "boss"])

    # Deduplicate while preserving order
    seen = set()
    final = []
    for t in tags:
        if t not in seen:
            seen.add(t)
            final.append(t)

    return final

# ============================================================
# EVOLUTION GRAPH ANALYSIS
# ============================================================

def build_evolution_graph(entries_map):
    forward = defaultdict(list)  # species -> [targets]
    reverse = defaultdict(list)  # species -> [pre-evos]

    for species_id, data in entries_map.items():
        evos = parse_evolutions(data.get("Evolutions", ""))
        for evo in evos:
            target = normalize_species_key(evo["target"])
            if target in entries_map:
                forward[species_id].append(target)
                reverse[target].append(species_id)

    return forward, reverse

def find_chain_roots(species_id, reverse):
    visited = set()
    q = deque([species_id])
    roots = set()

    while q:
        cur = q.popleft()
        if cur in visited:
            continue
        visited.add(cur)

        parents = reverse.get(cur, [])
        if not parents:
            roots.add(cur)
        else:
            for p in parents:
                q.append(p)

    if not roots:
        roots.add(species_id)
    return sorted(roots)

def collect_chain_from_root(root, forward):
    visited = set()
    q = deque([root])
    chain = []

    while q:
        cur = q.popleft()
        if cur in visited:
            continue
        visited.add(cur)
        chain.append(cur)

        for nxt in forward.get(cur, []):
            q.append(nxt)

    return chain

def compute_evolution_depth(species_id, reverse):
    """
    Minimum distance from any root pre-evo.
    """
    if not reverse.get(species_id):
        return 0

    visited = set()
    q = deque([(species_id, 0)])
    depths = []

    while q:
        cur, dist = q.popleft()
        if (cur, dist) in visited:
            continue
        visited.add((cur, dist))

        parents = reverse.get(cur, [])
        if not parents:
            depths.append(dist)
        else:
            for p in parents:
                q.append((p, dist + 1))

    if not depths:
        return 0
    return min(depths)

def determine_evolution_stage(species_id, forward, reverse):
    has_pre = len(reverse.get(species_id, [])) > 0
    has_next = len(forward.get(species_id, [])) > 0

    if not has_pre and not has_next:
        return "standalone"
    if not has_pre and has_next:
        # could be baby or basic; we infer "baby" later if BST is tiny or special
        return "base"
    if has_pre and has_next:
        return "middle"
    if has_pre and not has_next:
        return "final"

# ============================================================
# BUILD INDEX
# ============================================================

def build_index(species_entries):
    entries_map = {normalize_species_key(species_id): data for species_id, data in species_entries}
    ordered_species = [normalize_species_key(species_id) for species_id, _ in species_entries]

    forward, reverse = build_evolution_graph(entries_map)

    pokemon = []

    dex_lookup = {species_id: i + 1 for i, species_id in enumerate(ordered_species)}

    for species_id in ordered_species:
        data = entries_map[species_id]

        name = data.get("Name", species_id.title())
        types = parse_types(data.get("Types", ""))
        flags = parse_csv_field(data.get("Flags", ""))
        generation = parse_int(data.get("Generation", ""), 0)

        base_stats = parse_base_stats(data.get("BaseStats", ""))
        bst = sum(base_stats)

        catch_rate = parse_int(data.get("CatchRate", ""), 0)
        egg_groups = parse_csv_field(data.get("EggGroups", ""))
        hatch_steps = parse_int(data.get("HatchSteps", ""), 0)
        gender_ratio = data.get("GenderRatio", None)

        color = data.get("Color", None)
        shape = data.get("Shape", None)
        habitat = data.get("Habitat", None)

        legendary, mythical = detect_legendary_mythical(species_id, flags)
        ultra_beast = detect_ultra_beast(species_id, flags)
        paradox = detect_paradox(species_id, name, flags)
        fossil = detect_fossil(species_id, flags)
        starter = detect_starter(species_id, flags)
        pseudo_legendary = species_id in PSEUDO_LEGENDARIES

        regional_form_capable = species_id in REGIONAL_FORM_CAPABLE
        special_form_capable = species_id in SPECIAL_FORM_CAPABLE

        evo_stage = determine_evolution_stage(species_id, forward, reverse)
        evo_depth = compute_evolution_depth(species_id, reverse)
        is_final_evolution = len(forward.get(species_id, [])) == 0 and len(reverse.get(species_id, [])) > 0

        # "baby" heuristic
        # If it's a base evo but very weak and in a line, treat as baby
        if evo_stage == "base" and bst <= 320 and len(forward.get(species_id, [])) > 0:
            evo_stage_refined = "baby_or_base"
        else:
            evo_stage_refined = evo_stage

        roots = find_chain_roots(species_id, reverse)
        full_chain = []
        for r in roots:
            full_chain.extend(collect_chain_from_root(r, forward))

        # Deduplicate, then sort by dex for consistency
        full_chain = sorted(set(full_chain), key=lambda s: dex_lookup.get(s, 999999))

        bst_bucket = bst_tier(bst, legendary, mythical, ultra_beast, paradox)
        catch_bucket = catch_rate_tier(catch_rate, legendary, mythical)
        rarity_tag = encounter_rarity_tag(catch_rate, legendary, mythical, ultra_beast, paradox)

        entry = {
            "national_dex": dex_lookup[species_id],
            "species_id": species_id,
            "name": name,
            "types": types,
            "generation": generation if generation > 0 else None,

            "color": color,
            "shape": shape,
            "habitat": habitat,

            "base_stats": {
                "hp": base_stats[0],
                "attack": base_stats[1],
                "defense": base_stats[2],
                "special_attack": base_stats[3],
                "special_defense": base_stats[4],
                "speed": base_stats[5]
            },
            "bst": bst,
            "bst_tier": bst_bucket,

            "catch_rate": catch_rate if catch_rate > 0 else None,
            "catch_rate_tier": catch_bucket,
            "encounter_rarity": rarity_tag,

            "egg_groups": egg_groups,
            "hatch_steps": hatch_steps if hatch_steps > 0 else None,
            "gender_ratio": gender_ratio,

            "starter": starter,
            "fossil": fossil,
            "legendary": legendary,
            "mythical": mythical,
            "pseudo_legendary": pseudo_legendary,
            "ultra_beast": ultra_beast,
            "paradox": paradox,

            "regional_form_capable": regional_form_capable,
            "special_form_capable": special_form_capable,

            "evolution": {
                "stage": evo_stage_refined,
                "depth": evo_depth,
                "is_final_evolution": is_final_evolution,
                "pre_evolutions": sorted(reverse.get(species_id, []), key=lambda s: dex_lookup.get(s, 999999)),
                "evolves_to": sorted(forward.get(species_id, []), key=lambda s: dex_lookup.get(s, 999999)),
                "chain": full_chain
            },

            "trainer_suitability": [],  # filled after
            "flags": flags
        }

        entry["trainer_suitability"] = trainer_suitability_tags(entry)
        pokemon.append(entry)

    return pokemon

# ============================================================
# GROUPING / HELPERS
# ============================================================

def group_by_type(pokemon):
    result = {t: [] for t in TYPE_ORDER}
    for p in pokemon:
        for t in p["types"]:
            if t not in result:
                result[t] = []
            result[t].append(p)

    for t in result:
        result[t] = sorted(result[t], key=lambda x: (x["national_dex"], x["species_id"]))
    return result

def group_by_tag(pokemon, key):
    grouped = defaultdict(list)
    for p in pokemon:
        value = p.get(key)
        if isinstance(value, bool):
            if value:
                grouped["true"].append(p)
        elif isinstance(value, list):
            for v in value:
                grouped[v].append(p)
        elif value is not None:
            grouped[str(value)].append(p)

    for k in grouped:
        grouped[k] = sorted(grouped[k], key=lambda x: (x["national_dex"], x["species_id"]))
    return dict(grouped)

# ============================================================
# MARKDOWN OUTPUT
# ============================================================

def write_markdown(path: Path, pokemon):
    lines = []

    lines.append("# Pokémon Master Index (AI-Ready)")
    lines.append("")
    lines.append("AI ASSISTANT DIRECTIVE (JULES):")
    lines.append("This file is the master indexing reference for all Pokémon species in this project. Use it when generating trainer parties, encounter tables, evolution-aware rosters, loot tables, rarity pools, biome ecosystems, progression gating, and boss-tier selections.")
    lines.append("")
    lines.append("When designing content:")
    lines.append("- Prefer `trainer_suitability` and `bst_tier` for progression balance.")
    lines.append("- Prefer `encounter_rarity` and `catch_rate_tier` for wild encounter weighting.")
    lines.append("- Prefer `evolution.stage` and `evolution.depth` for level-appropriate team building.")
    lines.append("- Prefer `legendary`, `mythical`, `pseudo_legendary`, `ultra_beast`, and `paradox` for boss-tier or special-event logic.")
    lines.append("- Always cross-reference with `pokemon.txt` if a custom species, regional variant, or project-specific form is newly added.")
    lines.append("")
    lines.append("---")
    lines.append("")
    lines.append("## Metadata Key")
    lines.append("")
    lines.append("- **Core Format:** `DEX | SPECIES_ID | Name | [Types] | BST | BST Tier | Catch Tier | Evo Stage | Tags | Trainer Roles`")
    lines.append("- **Evo Stage:** `standalone`, `base`, `baby_or_base`, `middle`, `final`")
    lines.append("- **BST Tiers:** `weak`, `earlygame`, `midgame`, `lategame`, `ace`, `boss`")
    lines.append("- **Catch Tiers:** `very_easy`, `easy`, `normal`, `hard`, `rare`, `legendary`")
    lines.append("")
    lines.append(f"- **Total Pokémon indexed:** {len(pokemon)}")
    lines.append("")

    # Full master list
    lines.append("## Full Species Index")
    lines.append("")

    for p in pokemon:
        dex = str(p["national_dex"]).zfill(4)
        type_label = "/".join(p["types"]) if p["types"] else "UNKNOWN"

        tags = []
        if p["starter"]:
            tags.append("Starter")
        if p["fossil"]:
            tags.append("Fossil")
        if p["legendary"]:
            tags.append("Legendary")
        if p["mythical"]:
            tags.append("Mythical")
        if p["pseudo_legendary"]:
            tags.append("Pseudo")
        if p["ultra_beast"]:
            tags.append("UltraBeast")
        if p["paradox"]:
            tags.append("Paradox")
        if p["regional_form_capable"]:
            tags.append("RegionalCapable")
        if p["special_form_capable"]:
            tags.append("SpecialFormCapable")

        tags_str = ", ".join(tags) if tags else "Standard"
        roles_str = ", ".join(p["trainer_suitability"]) if p["trainer_suitability"] else "none"

        lines.append(
            f"- `{dex} | {p['species_id']} | {p['name']} | [{type_label}] | "
            f"{p['bst']} | {p['bst_tier']} | {p['catch_rate_tier']} | {p['evolution']['stage']} | "
            f"{tags_str} | {roles_str}`"
        )

    lines.append("")

    # Type breakdown
    lines.append("## Type Buckets")
    lines.append("")
    type_groups = group_by_type(pokemon)

    for t in TYPE_ORDER:
        lines.append(f"### {t.title()} Type")
        lines.append("")
        group = type_groups.get(t, [])
        if not group:
            lines.append("_No species found._")
            lines.append("")
            continue

        for p in group:
            dex = str(p["national_dex"]).zfill(4)
            lines.append(f"- `{dex} | {p['species_id']} | {p['name']} | BST {p['bst']} | {p['bst_tier']}`")
        lines.append("")

    # Progression buckets
    lines.append("## Progression Buckets")
    lines.append("")
    progression_order = ["weak", "earlygame", "midgame", "lategame", "ace", "boss"]

    for bucket in progression_order:
        lines.append(f"### {bucket}")
        lines.append("")
        group = [p for p in pokemon if p["bst_tier"] == bucket]
        if not group:
            lines.append("_No species found._")
            lines.append("")
            continue
        for p in group:
            dex = str(p["national_dex"]).zfill(4)
            lines.append(f"- `{dex} | {p['species_id']} | {p['name']} | BST {p['bst']}`")
        lines.append("")

    # Special pools
    lines.append("## Special Pools")
    lines.append("")

    special_sections = [
        ("Starters", lambda p: p["starter"]),
        ("Fossils", lambda p: p["fossil"]),
        ("Pseudo-Legendaries", lambda p: p["pseudo_legendary"]),
        ("Legendaries", lambda p: p["legendary"] and not p["mythical"]),
        ("Mythicals", lambda p: p["mythical"]),
        ("Ultra Beasts", lambda p: p["ultra_beast"]),
        ("Paradox Pokémon", lambda p: p["paradox"]),
        ("Regional Form Capable", lambda p: p["regional_form_capable"]),
        ("Special Form Capable", lambda p: p["special_form_capable"]),
    ]

    for title, predicate in special_sections:
        lines.append(f"### {title}")
        lines.append("")
        group = [p for p in pokemon if predicate(p)]
        if not group:
            lines.append("_No species found._")
            lines.append("")
            continue

        for p in group:
            dex = str(p["national_dex"]).zfill(4)
            lines.append(f"- `{dex} | {p['species_id']} | {p['name']}`")
        lines.append("")

    path.write_text("\n".join(lines), encoding="utf-8")

# ============================================================
# JSON OUTPUT
# ============================================================

def write_json(path: Path, pokemon):
    type_groups = group_by_type(pokemon)

    payload = {
        "meta": {
            "title": "Pokemon Master Index (AI-Ready)",
            "description": (
                "Master index for all Pokémon species in the project. Includes progression tiers, "
                "evolution chain analysis, rarity, special classifications, and AI-friendly trainer tags."
            ),
            "ai_assistant_directive": {
                "agent": "JULES",
                "text": (
                    "Use this file when generating trainer parties, encounter tables, evolution-aware rosters, "
                    "loot tables, rarity pools, biome ecosystems, progression gating, and boss-tier selections."
                )
            },
            "total_pokemon_indexed": len(pokemon),
            "type_order": TYPE_ORDER
        },
        "summary": {
            "type_groups": {
                t: [
                    {
                        "national_dex": p["national_dex"],
                        "species_id": p["species_id"],
                        "name": p["name"]
                    }
                    for p in type_groups.get(t, [])
                ]
                for t in type_groups
            },
            "special_pools": {
                "starters": [p["species_id"] for p in pokemon if p["starter"]],
                "fossils": [p["species_id"] for p in pokemon if p["fossil"]],
                "pseudo_legendaries": [p["species_id"] for p in pokemon if p["pseudo_legendary"]],
                "legendaries": [p["species_id"] for p in pokemon if p["legendary"] and not p["mythical"]],
                "mythicals": [p["species_id"] for p in pokemon if p["mythical"]],
                "ultra_beasts": [p["species_id"] for p in pokemon if p["ultra_beast"]],
                "paradox": [p["species_id"] for p in pokemon if p["paradox"]],
                "regional_form_capable": [p["species_id"] for p in pokemon if p["regional_form_capable"]],
                "special_form_capable": [p["species_id"] for p in pokemon if p["special_form_capable"]]
            }
        },
        "pokemon": pokemon
    }

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

    pokemon = build_index(species_entries)

    output_md_path = script_dir / OUTPUT_MD
    output_json_path = script_dir / OUTPUT_JSON
    write_markdown(output_md_path, pokemon)
    write_json(output_json_path, pokemon)

    print(f"Done! Generated:")
    print(f"  - {output_md_path}")
    print(f"  - {output_json_path}")
    print(f"Indexed Pokémon: {len(pokemon)}")

if __name__ == "__main__":
    main()