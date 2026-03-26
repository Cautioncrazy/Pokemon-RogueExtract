import os
import random
from tools.pbs_generator.pbs_parser import PBSFile, PBSSection


def _default_pbs_dir():
    return os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "PBS"))

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

def _scan_for_bgm_files():
    """Scans the Audio/BGM directory for files starting with 'bgm' and returns a list of base names without extensions."""
    bgm_files = []
    # Audio/BGM is typical in the repo root (../../Audio/BGM)
    bgm_dir = os.path.abspath(os.path.join(_default_pbs_dir(), "..", "Audio", "BGM"))
    if os.path.exists(bgm_dir):
        for f in os.listdir(bgm_dir):
            if f.lower().startswith("bgm") and os.path.isfile(os.path.join(bgm_dir, f)):
                base_name, _ = os.path.splitext(f)
                bgm_files.append(base_name)
    return bgm_files

def generate_map_metadata(start_id, end_id, theme=None, pbs_dir=None, overwrite=False):
    """
    Mass generates Map Metadata for a range of map IDs, injecting random names,
    the Dungeon flag, and randomly scanned BGM files.
    """
    if pbs_dir is None:
        pbs_dir = _default_pbs_dir()
    filepath = os.path.join(pbs_dir, "map_metadata.txt")
    if not os.path.exists(filepath):
        raise FileNotFoundError(f"map_metadata.txt not found in PBS folder: {filepath}")
    pbs = PBSFile(filepath)

    available_bgms = _scan_for_bgm_files()

    count = 0
    for map_id in range(start_id, end_id + 1):
        header_prefix = f"[{map_id:03d}]"

        if pbs.has_section(header_prefix):
            if overwrite:
                pbs.remove_section(header_prefix)
                print(f"Map {map_id} already exists in map_metadata.txt. Overwriting.")
            else:
                print(f"Map {map_id} already exists in map_metadata.txt. Skipping appending.")
                continue

        name = generate_random_dungeon_name(theme)

        # Create the new section block
        new_section = PBSSection(f"{header_prefix}   # {name}")
        new_section.add_line(f"Name = {name}")
        new_section.add_line("Dungeon = true")

        # Inject randomized BGM if available
        if available_bgms:
            selected_bgm = random.choice(available_bgms)
            new_section.add_line(f"BGM = {selected_bgm},100,100")

        # Add the separator comment to the previous section or before this one
        if not pbs.sections:
            pbs.preamble.append("#-------------------------------")
        else:
            last_section = pbs.sections[-1]
            if last_section.lines and not last_section.lines[-1].startswith("#-------------------------------"):
                last_section.add_line("#-------------------------------")

        pbs.add_section(new_section)
        count += 1

    if count > 0:
        pbs.save()
        print(f"Generated/Updated Map Metadata for {count} maps.")
    return count
