import os
import random
from tools.pbs_generator.pbs_parser import PBSFile, PBSSection

def generate_random_dungeon_name(theme=None):
    prefixes = ["Mystic", "Shadow", "Crystal", "Forgotten", "Ancient", "Abyssal", "Verdant", "Silent", "Echoing"]
    suffixes = ["Cave", "Ruins", "Depths", "Sanctuary", "Labyrinth", "Hollow", "Grotto", "Chasm"]

    if theme:
        # We can expand these to be more thematic later
        theme_lower = theme.lower()
        if theme_lower == 'grass':
            prefixes = ["Verdant", "Overgrown", "Leafy", "Bramble"]
        elif theme_lower == 'poison':
            prefixes = ["Toxic", "Venomous", "Blighted", "Noxious"]
            suffixes = ["Swamp", "Bog", "Mire", "Sludge"]

    return f"{random.choice(prefixes)} {random.choice(suffixes)}"

def append_map_metadata(map_id, name=None, theme=None, pbs_dir="PBS"):
    filepath = os.path.join(pbs_dir, "map_metadata.txt")
    pbs = PBSFile(filepath)

    header_prefix = f"[{map_id:03d}]"
    if pbs.has_section(header_prefix):
        print(f"Map {map_id} already exists in map_metadata.txt. Skipping appending.")
        return

    if not name:
        name = generate_random_dungeon_name(theme)

    # Create the new section block
    new_section = PBSSection(f"{header_prefix}   # {name}")
    new_section.add_line(f"Name = {name}")
    new_section.add_line("Dungeon = true")

    # Pokémon Essentials typically has a separator comment between sections
    if not pbs.sections:
        pbs.preamble.append("#-------------------------------")
    else:
        # Add the separator comment to the previous section or before this one
        last_section = pbs.sections[-1]
        if last_section.lines and not last_section.lines[-1].startswith("#-------------------------------"):
            last_section.add_line("#-------------------------------")

    pbs.add_section(new_section)
    pbs.save()
    print(f"Appended Map {map_id} ({name}) to map_metadata.txt")
    return name
