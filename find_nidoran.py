import json

with open("tools/pbs_generator/pokemon_index.json", "r") as f:
    index = json.load(f)

for p in index["pokemon"]:
    if "NIDORAN" in p["species_id"] or "TSAR" in p["species_id"]:
        print(p["species_id"])
