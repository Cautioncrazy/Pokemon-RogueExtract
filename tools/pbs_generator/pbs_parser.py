import os
import re

class PBSSection:
    def __init__(self, header):
        self.header = header
        self.lines = []

    def add_line(self, line):
        self.lines.append(line)

    def get_lines(self):
        return self.lines

    def get_key_values(self):
        """Returns a list of (key, value) tuples, ignoring comments and blank lines."""
        key_values = []
        for line in self.lines:
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            if '=' in line:
                key, value = line.split('=', 1)
                key_values.append((key.strip(), value.strip()))
            else:
                # Handle encounters.txt style where it's just a comma separated list
                key_values.append((None, line))
        return key_values


class PBSFile:
    def __init__(self, filepath):
        self.filepath = filepath
        self.sections = []
        self.preamble = [] # Lines before the first section
        self.load()

    def load(self):
        if not os.path.exists(self.filepath):
            return

        with open(self.filepath, 'r', encoding='utf-8') as f:
            current_section = None
            for line in f:
                stripped = line.strip()
                # Check for a new section header like [078,0] # F1-F4
                # It might have trailing comments, so we search for a bracketed string
                match = re.match(r'^(\[[^\]]+\])', stripped)
                if match:
                    header = stripped  # keep trailing comments for rewriting
                    current_section = PBSSection(header)
                    self.sections.append(current_section)
                elif current_section is not None:
                    current_section.add_line(line.rstrip('\n'))
                else:
                    self.preamble.append(line.rstrip('\n'))

    def save(self):
        with open(self.filepath, 'w', encoding='utf-8') as f:
            for line in self.preamble:
                f.write(f"{line}\n")

            for section in self.sections:
                f.write(f"{section.header}\n")
                for line in section.lines:
                    f.write(f"{line}\n")

    def has_section(self, header_prefix):
        """Checks if a section header starts with the prefix (e.g., [078,0]) ignoring comments."""
        return any(s.header.startswith(header_prefix) for s in self.sections)

    def add_section(self, section):
        self.sections.append(section)

    def get_section(self, header_prefix):
        for s in self.sections:
            if s.header.startswith(header_prefix):
                return s
        return None

    def remove_section(self, header_prefix):
        """Safely deletes an existing section (and trailing empty space) from the parsed tree."""
        # Find index of the section
        index_to_remove = -1
        for i, s in enumerate(self.sections):
            if s.header.startswith(header_prefix):
                index_to_remove = i
                break

        if index_to_remove >= 0:
            del self.sections[index_to_remove]
            # Clean up any trailing empty lines or separators in the previous section if needed
            # Although standard procedure just appends at the bottom.
            return True
        return False
