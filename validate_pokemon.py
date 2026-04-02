import re
import json

def load_pokemon_index():
    with open("tools/pbs_generator/pokemon_index.json", "r") as f:
        return json.load(f)

def validate_trainers():
    index = load_pokemon_index()
    valid_names = set(p["species_id"] for p in index["pokemon"])

    with open("tools/pbs_generator/trainers.md", "r") as f:
        for line in f:
            if line.startswith("* **Approved Pool:**"):
                # Extract the comma separated list
                pool_str = line.split(":**")[1].strip()
                if pool_str.endswith("."):
                    pool_str = pool_str[:-1]
                pokemon_list = [p.strip() for p in pool_str.split(",")]
                for p in pokemon_list:
                    if p not in valid_names:
                        print(f"INVALID POKEMON FOUND: {p}")

validate_trainers()
