import os
import sys

# Add the tools directory to the python path so it can be run standalone easily
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..')))

from tools.pbs_generator.pbs_parser import PBSFile, PBSSection

def setup_artifacts(pbs_dir):
    """
    Appends the Hollowed Soul and Persistent Artifacts to items.txt using the PBS parser.
    """
    items_path = os.path.join(pbs_dir, 'items.txt')
    if not os.path.exists(items_path):
        return "Error: items.txt not found in " + pbs_dir

    pbs_file = PBSFile(items_path)

    items_to_add = [
        {
            "id": "[HOLLOWED_SOUL]",
            "Name": "Hollowed Soul",
            "NamePlural": "Hollowed Souls",
            "Pocket": "8", # Key Items pocket
            "Price": "0",
            "Flags": "KeyItem",
            "Description": "A faint, glowing wisp salvaged from the abyss. It resonates with a quiet, enduring power."
        },
        {
            "id": "[ARTIFACT_FORTUNE]",
            "Name": "Fortune Coin",
            "NamePlural": "Fortune Coins",
            "Pocket": "8",
            "Price": "0",
            "Flags": "KeyItem",
            "Description": "A glimmering coin radiating ancient greed. Increases all money earned from battles by 25%."
        },
        {
            "id": "[ARTIFACT_VITALITY]",
            "Name": "Vitality Root",
            "NamePlural": "Vitality Roots",
            "Pocket": "8",
            "Price": "0",
            "Flags": "KeyItem",
            "Description": "An ever-growing root pulsing with life energy. Restores 5% of the party's Max HP after surviving a battle."
        },
        {
            "id": "[ARTIFACT_WISDOM]",
            "Name": "Wisdom Crystal",
            "NamePlural": "Wisdom Crystals",
            "Pocket": "8",
            "Price": "0",
            "Flags": "KeyItem",
            "Description": "A jagged shard of glass that sharpens the mind. Increases all EXP gained by the party by 15%."
        }
    ]

    added_count = 0
    for item_data in items_to_add:
        # Check if it already exists
        if pbs_file.has_section(item_data["id"]):
            continue

        # Create a new section
        section = PBSSection(item_data["id"])

        # Add properties
        for key, value in item_data.items():
            if key == "id":
                continue
            section.add_line(f"{key} = {value}")

        # Add a trailing separator
        section.add_line("#-------------------------------")

        pbs_file.add_section(section)
        added_count += 1

    if added_count > 0:
        pbs_file.save()
        return f"Successfully appended {added_count} Artifact items to items.txt."
    else:
        return "Artifact items already exist in items.txt. No changes made."

if __name__ == "__main__":
    pbs_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', 'PBS'))
    print(setup_artifacts(pbs_dir))
