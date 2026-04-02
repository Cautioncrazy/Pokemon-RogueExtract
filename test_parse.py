import re

with open("tools/pbs_generator/trainers.md", "r") as f:
    for line in f:
        stripped = line.strip()
        if stripped.startswith("* **Approved Pool:**"):
            raw = stripped.split(":**", 1)[1].strip().rstrip(".")
            pool = [p.strip().replace("*", "").upper() for p in raw.split(",") if p.strip().replace("*", "")]
            print(pool[:3])
