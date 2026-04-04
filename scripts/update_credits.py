import os
import re
from collections import defaultdict

def extract_credits():
    plugins_dir = 'Plugins'
    author_plugins = defaultdict(list)

    # regex to find Name and Credits
    name_pattern = re.compile(r'^Name\s*=\s*(.+)', re.IGNORECASE)
    credits_pattern = re.compile(r'^Credits\s*=\s*(.+)', re.IGNORECASE)

    if not os.path.exists(plugins_dir):
        print(f"{plugins_dir} not found.")
        return

    for item in os.listdir(plugins_dir):
        plugin_path = os.path.join(plugins_dir, item)
        if os.path.isdir(plugin_path):
            meta_file = os.path.join(plugin_path, 'meta.txt')
            if os.path.exists(meta_file):
                plugin_name = ""
                credits_list = []

                with open(meta_file, 'r', encoding='utf-8') as f:
                    for line in f:
                        name_match = name_pattern.match(line)
                        if name_match:
                            plugin_name = name_match.group(1).strip()

                        credit_match = credits_pattern.match(line)
                        if credit_match:
                            credits_raw = credit_match.group(1).strip()
                            # Split by commas and strip whitespace
                            credits_list = [c.strip() for c in credits_raw.split(',')]
                            # Specifically map ThatWelshOne_ to the explicit alias ThatHerts requested by user if present
                            # Or just add ThatHerts if missing and it's the MQS plugin
                            if plugin_name == "Modern Quest System + UI":
                                if "ThatHerts" not in credits_list:
                                    credits_list.append("ThatHerts")

                if plugin_name and credits_list:
                    for author in credits_list:
                        author_plugins[author].append(plugin_name)

    # Write to credits.md
    with open('credits.md', 'w', encoding='utf-8') as f:
        # Sort authors alphabetically
        for author in sorted(author_plugins.keys(), key=lambda x: x.lower()):
            f.write(f"## {author}\n")
            for plugin in sorted(author_plugins[author]):
                f.write(f"* {plugin}\n")
            f.write("\n")

if __name__ == '__main__':
    extract_credits()
