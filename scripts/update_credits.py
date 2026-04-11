import re
from collections import defaultdict

def parse_and_group_credits(input_file):
    # This dictionary maps Plugin Name -> List of Authors
    plugin_credits = defaultdict(list)
    current_author = None
    
    with open(input_file, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            
            # Identify the Author (Assumes standard markdown headers like ## Author Name)
            # Adjust the `.startswith()` depending on how your credits.md is formatted
            if line.startswith('## ') or line.startswith('### '):
                current_author = line.lstrip('# ').strip()
                
            # Identify the Plugin/Mod (Assumes markdown bullet points like * Plugin Name)
            elif line.startswith('- ') or line.startswith('* '):
                if current_author:
                    plugin_name = line.lstrip('- *').strip()
                    
                    # Prevent duplicate author entries for the same plugin
                    if current_author not in plugin_credits[plugin_name]:
                        plugin_credits[plugin_name].append(current_author)

    return plugin_credits

def export_clean_credits(plugin_credits, output_file):
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("# Mod & Plugin Credits\n\n")
        
        # Sort plugins alphabetically for a clean list
        for plugin in sorted(plugin_credits.keys()):
            f.write(f"### {plugin}\n")
            
            # Sort authors alphabetically within that plugin
            authors = sorted(plugin_credits[plugin])
            f.write(f"* **Authors:** {', '.join(authors)}\n\n")

if __name__ == "__main__":
    input_md = 'credits.md'
    output_md = 'grouped_credits.md'  # Or overwrite credits.md directly if preferred
    
    print("Parsing credits...")
    parsed_data = parse_and_group_credits(input_md)
    
    print("Exporting grouped credits...")
    export_clean_credits(parsed_data, output_md)
    
    print(f"Success! Grouped {len(parsed_data)} unique plugins.")
