import os
import random
from tools.pbs_generator.pbs_parser import PBSFile, PBSSection
from tools.pbs_generator.encounter_gen import calculate_levels

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

    current_class = None
    parsing_classes = False

    with open(md_filepath, 'r', encoding='utf-8') as f:
        for line in f:
            stripped = line.strip()
            if stripped == "## Trainer Classes":
                parsing_classes = True
                continue
            elif stripped.startswith("## "):
                parsing_classes = False
                current_class = stripped[3:].strip()
                class_pools[current_class] = []
                continue

            if parsing_classes and stripped.startswith("- "):
                # Format: - HIKER (Themes: Heavy, Rock)
                import re
                match = re.match(r'- (\w+)(?:\s*\(Themes:\s*(.+)\))?', stripped)
                if match:
                    trainer_class = match.group(1)
                    themes_str = match.group(2)
                    if themes_str:
                        themes = [t.strip().lower() for t in themes_str.split(',')]
                        class_themes[trainer_class] = themes
                    else:
                        class_themes[trainer_class] = []
            elif not parsing_classes and current_class and stripped.startswith("- "):
                pokemon = stripped[2:].strip().upper()
                class_pools[current_class].append(pokemon)

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

def generate_trainers(floor_number, theme, pbs_dir="PBS", md_filepath="tools/pbs_generator/trainers.md"):
    """Generates a dynamic trainer for the floor's theme."""
    class_themes, class_pools = load_trainers_rules(md_filepath)

    if not class_themes or not class_pools:
        print("Error: trainers.md not found or empty.")
        return

    # Find Trainer Classes that support this theme
    valid_classes = []
    theme_lower = theme.lower() if theme else ""
    for trainer_class, themes in class_themes.items():
        if theme_lower in themes:
            valid_classes.append(trainer_class)

    if not valid_classes:
        print(f"Warning: No Trainer Class found for theme '{theme}'. Defaulting to random.")
        valid_classes = list(class_themes.keys())

    trainer_class = random.choice(valid_classes)

    # Generic names for trainers
    first_names = ["Bob", "Alice", "Charlie", "Diana", "Eve", "Frank", "Grace", "Heidi", "Ivan", "Judy", "Mallory", "Victor"]
    trainer_name = random.choice(first_names)

    version = floor_number - 1 # 0-indexed version matching the floor
    if version < 0: version = 0

    filepath = os.path.join(pbs_dir, "trainers.txt")
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
    available_pokemon = class_pools.get(trainer_class, [])

    if not available_pokemon:
         print(f"Warning: No Pokémon pool defined for {trainer_class}. Using Pikachu fallback.")
         available_pokemon = ["PIKACHU"]

    min_lvl, max_lvl = calculate_levels(floor_number)

    selected_pokemon = random.choices(available_pokemon, k=party_size)

    for pkmn in selected_pokemon:
        level = random.randint(min_lvl, max_lvl)
        section.add_line(f"Pokemon = {pkmn},{level}")

    pbs.add_section(section)
    pbs.save()
    print(f"Generated Trainer {header} (Class: {trainer_class}) on Floor {floor_number} with theme '{theme}'")
