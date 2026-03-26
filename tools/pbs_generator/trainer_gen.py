import os
import random
from tools.pbs_generator.pbs_parser import PBSFile, PBSSection
from tools.pbs_generator.encounter_gen import calculate_levels
from tools.pbs_generator.theme_data import get_species_pool_for_theme, get_pokemon_entry_map


def _default_pbs_dir():
    return os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "PBS"))

def load_trainers_rules(md_filepath):
    """
    Parses trainers.md to return:
    - class_themes: {TrainerClass: [Themes]}
    - class_pools: {TrainerClass: [Pokemon list]}
    """
    class_themes = {}
    class_pools = {}

    if not os.path.exists(md_filepath):
        return class_themes, class_pools

    current_classes = []
    parsed_any_new_format = False

    with open(md_filepath, 'r', encoding='utf-8') as f:
        for line in f:
            stripped = line.strip()

            # New format:
            # ### `CLASS` or ### `CLASS_A` / `CLASS_B`
            if stripped.startswith("### "):
                import re
                header = stripped[4:].strip()
                tokens = re.findall(r'`([^`]+)`', header)
                if not tokens and header:
                    tokens = [header]
                current_classes = []
                for token in tokens:
                    for part in token.split("/"):
                        class_name = part.strip().upper()
                        if class_name:
                            current_classes.append(class_name)
                            class_themes.setdefault(class_name, [])
                            class_pools.setdefault(class_name, [])
                if current_classes:
                    parsed_any_new_format = True
                continue

            if current_classes and stripped.startswith("* **Map Themes:**"):
                raw = stripped.split(":", 1)[1].strip()
                themes = [t.strip().lower() for t in raw.split(",") if t.strip()]
                for trainer_class in current_classes:
                    class_themes[trainer_class] = themes
                continue

            if current_classes and stripped.startswith("* **Approved Pool:**"):
                raw = stripped.split(":", 1)[1].strip().rstrip(".")
                pool = [p.strip().upper() for p in raw.split(",") if p.strip()]
                for trainer_class in current_classes:
                    class_pools[trainer_class].extend(pool)
                continue

            # Legacy fallback format:
            # - HIKER (Themes: Heavy, Rock)
            # ## HIKER
            if not parsed_any_new_format:
                if stripped == "## Trainer Classes":
                    current_classes = ["__PARSING_CLASSES__"]
                    continue
                if stripped.startswith("## "):
                    class_name = stripped[3:].strip().upper()
                    current_classes = [class_name]
                    class_pools.setdefault(class_name, [])
                    continue

                if current_classes == ["__PARSING_CLASSES__"] and stripped.startswith("- "):
                    import re
                    match = re.match(r'- (\w+)(?:\s*\(Themes:\s*(.+)\))?', stripped)
                    if match:
                        trainer_class = match.group(1).upper()
                        themes_str = match.group(2)
                        if themes_str:
                            themes = [t.strip().lower() for t in themes_str.split(',')]
                            class_themes[trainer_class] = themes
                        else:
                            class_themes[trainer_class] = []
                    continue

                if current_classes and current_classes != ["__PARSING_CLASSES__"] and stripped.startswith("- "):
                    pokemon = stripped[2:].strip().upper()
                    class_pools[current_classes[0]].append(pokemon)

    return class_themes, class_pools

def calculate_party_size(floor_number):
    """Calculates party size based on floor number."""
    if floor_number <= 3:
        return random.randint(1, 2)
    elif floor_number <= 7:
        return random.randint(2, 4)
    elif floor_number <= 12:
        return random.randint(3, 5)
    else:
        return random.randint(4, 6)


def _target_trainer_roles(floor_number):
    if floor_number <= 3:
        return {"earlygame", "midgame"}
    if floor_number <= 7:
        return {"midgame", "lategame"}
    if floor_number <= 12:
        return {"lategame", "gym_ace", "elite_four"}
    return {"gym_ace", "elite_four", "champion", "boss"}


def _filter_pool_for_floor(species_pool, floor_number):
    entry_map = get_pokemon_entry_map()
    if not entry_map:
        return species_pool

    roles = _target_trainer_roles(floor_number)
    filtered = []
    for species_id in species_pool:
        entry = entry_map.get(species_id)
        if not entry:
            filtered.append(species_id)
            continue
        if entry.get("legendary") or entry.get("mythical") or entry.get("ultra_beast") or entry.get("paradox"):
            continue
        suitability = set(entry.get("trainer_suitability") or [])
        if suitability.intersection(roles):
            filtered.append(species_id)

    return filtered if filtered else species_pool


def generate_trainers(floor_number, theme, pbs_dir=None, md_filepath=None):
    """Generates a dynamic trainer for the floor's theme."""
    if pbs_dir is None:
        pbs_dir = _default_pbs_dir()
    if md_filepath is None:
        md_filepath = os.path.join(os.path.dirname(__file__), "trainers.md")
    class_themes, class_pools = load_trainers_rules(md_filepath)

    if not class_themes or not class_pools:
        raise ValueError(f"trainers.md not found or empty: {md_filepath}")

    # Find Trainer Classes that support this theme
    valid_classes = []
    theme_lower = theme.lower() if theme else ""
    for trainer_class, themes in class_themes.items():
        if theme_lower in themes:
            valid_classes.append(trainer_class)

    if not valid_classes:
        # Fallback: infer suitable classes by overlap with JSON-derived theme pool.
        theme_pool = set(get_species_pool_for_theme(theme, include_special_boss=False))
        overlap_scored = []
        for trainer_class, pool in class_pools.items():
            class_pool = {p.upper() for p in pool}
            score = len(class_pool.intersection(theme_pool))
            if score > 0:
                overlap_scored.append((trainer_class, score))

        if overlap_scored:
            overlap_scored.sort(key=lambda x: x[1], reverse=True)
            best_score = overlap_scored[0][1]
            valid_classes = [cls for cls, score in overlap_scored if score == best_score]
            print(
                f"Info: No explicit Trainer Class mapping for theme '{theme}'. "
                f"Using best-overlap classes: {', '.join(valid_classes)}"
            )
        else:
            print(f"Warning: No Trainer Class found for theme '{theme}'. Defaulting to random.")
            valid_classes = list(class_themes.keys())

    trainer_class = random.choice(valid_classes)

    # Generic names for trainers
    first_names = ["Bob", "Alice", "Charlie", "Diana", "Eve", "Frank", "Grace", "Heidi", "Ivan", "Judy", "Mallory", "Victor"]
    trainer_name = random.choice(first_names)

    version = floor_number - 1 # 0-indexed version matching the floor
    if version < 0: version = 0

    filepath = os.path.join(pbs_dir, "trainers.txt")
    if not os.path.exists(filepath):
        raise FileNotFoundError(f"trainers.txt not found in PBS folder: {filepath}")
    pbs = PBSFile(filepath)

    header = f"[{trainer_class},{trainer_name},{version}]"
    if version == 0:
        header = f"[{trainer_class},{trainer_name}]"

    if pbs.has_section(header):
        # We can append multiple with the same header in v21.1 if needed,
        # but typically names are distinct. To be safe, skip or pick a new name.
        print(f"Trainer section {header} already exists. Appending unique ID to name.")
        trainer_name = f"{trainer_name}_{random.randint(100, 999)}"
        if version == 0:
            header = f"[{trainer_class},{trainer_name}]"
        else:
            header = f"[{trainer_class},{trainer_name},{version}]"

    # Add space between sections
    if pbs.sections:
        last_section = pbs.sections[-1]
        if last_section.lines and not last_section.lines[-1].startswith("#-------------------------------"):
             last_section.add_line("#-------------------------------")
    else:
        pbs.preamble.append("#-------------------------------")

    section = PBSSection(header)

    # Simple Lose Text based on level/version
    if version == 0:
         section.add_line("LoseText = You got me!")
    else:
         section.add_line(f"LoseText = I couldn't handle the floor {floor_number} pressure!")

    party_size = calculate_party_size(floor_number)
    available_pokemon = [p.upper() for p in class_pools.get(trainer_class, [])]
    theme_pool = get_species_pool_for_theme(theme, include_special_boss=False)

    # Keep trainer class identity from trainers.md while enriching with index data.
    if available_pokemon and theme_pool:
        themed_class_pool = [p for p in available_pokemon if p in set(theme_pool)]
        if themed_class_pool:
            available_pokemon = themed_class_pool
    elif theme_pool:
        available_pokemon = theme_pool

    if not available_pokemon:
         print(f"Warning: No Pokémon pool defined for {trainer_class}. Using Pikachu fallback.")
         available_pokemon = ["PIKACHU"]

    available_pokemon = _filter_pool_for_floor(available_pokemon, floor_number)

    min_lvl, max_lvl = calculate_levels(floor_number)

    selected_pokemon = random.choices(available_pokemon, k=party_size)

    for pkmn in selected_pokemon:
        level = random.randint(min_lvl, max_lvl)
        section.add_line(f"Pokemon = {pkmn},{level}")

    pbs.add_section(section)
    pbs.save()
    print(f"Generated Trainer {header} (Class: {trainer_class}) on Floor {floor_number} with theme '{theme}'")
    return True
