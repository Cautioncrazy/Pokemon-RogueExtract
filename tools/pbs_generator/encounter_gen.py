import os
import random
from tools.pbs_generator.pbs_parser import PBSFile, PBSSection


def _default_pbs_dir():
    return os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "PBS"))

def load_encounters_rules(md_filepath):
    """Parses encounters.md to return a dictionary of {Theme: [Pokemon list]}"""
    rules = {}
    if not os.path.exists(md_filepath):
        return rules

    current_theme = None
    with open(md_filepath, 'r', encoding='utf-8') as f:
        for line in f:
            stripped = line.strip()
            if stripped.startswith("## "):
                current_theme = stripped[3:].strip()
                rules[current_theme] = []
            elif stripped.startswith("- ") and current_theme:
                pokemon = stripped[2:].strip().upper()
                rules[current_theme].append(pokemon)
    return rules

def calculate_levels(floor_number):
    """Calculates min and max levels based on floor number."""
    # Assuming the "Base Level 5 + 2 per floor" scaling example
    base_min = max(1, 1 + (floor_number - 1) * 2)
    base_max = max(base_min + 2, 5 + (floor_number - 1) * 2)

    return base_min, base_max

def generate_encounters(map_id, version, floor_number, theme, pbs_dir=None, md_filepath=None):
    """Generates encounter entries based on theme and floor number."""
    if pbs_dir is None:
        pbs_dir = _default_pbs_dir()
    if md_filepath is None:
        md_filepath = os.path.join(os.path.dirname(__file__), "encounters.md")
    rules = load_encounters_rules(md_filepath)
    if not rules:
        raise ValueError(f"encounters.md not found or empty: {md_filepath}")

    # Validations
    if not theme or theme not in rules:
        print(f"Warning: Theme '{theme}' invalid or not specified.")
        theme = random.choice(list(rules.keys()))
        print(f"Defaulting to random: '{theme}'.")

    available_pokemon = rules[theme]
    if not available_pokemon:
        raise ValueError(f"No Pokémon defined for theme '{theme}' in {md_filepath}")

    filepath = os.path.join(pbs_dir, "encounters.txt")
    if not os.path.exists(filepath):
        raise FileNotFoundError(f"encounters.txt not found in PBS folder: {filepath}")
    pbs = PBSFile(filepath)

    header = f"[{map_id:03d},{version}]"

    if pbs.has_section(header):
        print(f"Encounter section {header} already exists. Skipping.")
        return False

    # Add space between sections if needed
    if pbs.sections:
        last_section = pbs.sections[-1]
        if last_section.lines and last_section.lines[-1].strip() != '':
             last_section.add_line("")

    # Create new section
    floor_comment = f" # F{floor_number} ({theme})"
    section = PBSSection(f"{header}{floor_comment}")

    encounter_density = 10 if floor_number > 4 else 5
    section.add_line(f"Cave,{encounter_density}")

    min_lvl, max_lvl = calculate_levels(floor_number)

    # We want up to 10 unique Pokemon if possible
    sample_size = min(10, len(available_pokemon))
    selected = random.sample(available_pokemon, sample_size)

    # Pad if not enough unique pokemon
    while len(selected) < 10:
        selected.append(random.choice(available_pokemon))

    weights = [20, 20, 10, 10, 10, 10, 10, 5, 4, 1]

    for i in range(10):
        weight = weights[i]
        pkmn = selected[i]
        section.add_line(f"    {weight},{pkmn},{min_lvl},{max_lvl}")

    pbs.add_section(section)
    pbs.save()
    print(f"Generated Encounter {header} for Map {map_id} on Floor {floor_number} with theme '{theme}'")
    return True
