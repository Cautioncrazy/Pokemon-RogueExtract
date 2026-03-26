import sys
import os
from PyQt6.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
                             QLabel, QLineEdit, QPushButton, QComboBox, QSpinBox,
                             QTextEdit, QFrame, QGridLayout)
from PyQt6.QtCore import Qt
from PyQt6.QtGui import QFont, QColor, QPalette

# Add the tools directory to the python path so it can be run standalone easily
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..')))

from tools.pbs_generator.map_metadata_gen import append_map_metadata
from tools.pbs_generator.encounter_gen import generate_encounters
from tools.pbs_generator.trainer_gen import generate_trainers

class GlassWidget(QFrame):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setStyleSheet("""
            QFrame {
                background-color: rgba(255, 255, 255, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 15px;
            }
        """)

class PBSGeneratorApp(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Pokémon Rogue Extract - PBS Generator")
        self.setMinimumSize(600, 500)

        # Main Theme - Dark Glassmorphism
        self.setStyleSheet("""
            QMainWindow {
                background-color: #1e1e24;
            }
            QLabel {
                color: white;
                font-family: 'Segoe UI', sans-serif;
                font-size: 14px;
                background-color: transparent;
                border: none;
            }
            QPushButton {
                background-color: rgba(64, 128, 255, 0.6);
                color: white;
                border: 1px solid rgba(255, 255, 255, 0.3);
                border-radius: 10px;
                padding: 8px 15px;
                font-weight: bold;
            }
            QPushButton:hover {
                background-color: rgba(64, 128, 255, 0.8);
            }
            QPushButton:pressed {
                background-color: rgba(64, 128, 255, 1.0);
            }
            QLineEdit, QSpinBox, QComboBox {
                background-color: rgba(0, 0, 0, 0.3);
                color: white;
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 5px;
                padding: 5px;
            }
            QTextEdit {
                background-color: rgba(0, 0, 0, 0.3);
                color: #a0a0a0;
                border: 1px solid rgba(255, 255, 255, 0.1);
                border-radius: 8px;
            }
        """)

        main_widget = QWidget()
        self.setCentralWidget(main_widget)
        main_layout = QVBoxLayout(main_widget)
        main_layout.setContentsMargins(20, 20, 20, 20)
        main_layout.setSpacing(20)

        # Title
        title_label = QLabel("PBS Floor Generator")
        title_label.setFont(QFont("Segoe UI", 24, QFont.Weight.Bold))
        title_label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        title_label.setStyleSheet("color: #4da6ff; background-color: transparent; border: none;")
        main_layout.addWidget(title_label)

        # Glass Panel for Controls
        control_panel = GlassWidget()
        control_layout = QGridLayout(control_panel)
        control_layout.setContentsMargins(20, 20, 20, 20)
        control_layout.setSpacing(15)

        # Map ID Input
        control_layout.addWidget(QLabel("Target Map ID:"), 0, 0)
        self.map_id_spin = QSpinBox()
        self.map_id_spin.setRange(1, 999)
        self.map_id_spin.setValue(100)
        control_layout.addWidget(self.map_id_spin, 0, 1)

        # Floor Number
        control_layout.addWidget(QLabel("Floor Number:"), 1, 0)
        self.floor_spin = QSpinBox()
        self.floor_spin.setRange(1, 999)
        self.floor_spin.setValue(1)
        control_layout.addWidget(self.floor_spin, 1, 1)

        # Theme Selection
        control_layout.addWidget(QLabel("Floor Theme:"), 2, 0)
        self.theme_combo = QComboBox()
        self.populate_themes()
        control_layout.addWidget(self.theme_combo, 2, 1)

        # Generate Button
        self.generate_btn = QPushButton("Generate Floor Data")
        self.generate_btn.clicked.connect(self.on_generate_clicked)
        control_layout.addWidget(self.generate_btn, 3, 0, 1, 2)

        main_layout.addWidget(control_panel)

        # Log Output Console
        self.log_console = QTextEdit()
        self.log_console.setReadOnly(True)
        self.log_console.setPlaceholderText("Generation logs will appear here...")
        main_layout.addWidget(self.log_console)

    def log(self, message):
        self.log_console.append(message)

    def populate_themes(self):
        themes = ["Random"]
        md_filepath = os.path.abspath(os.path.join(os.path.dirname(__file__), 'encounters.md'))
        if os.path.exists(md_filepath):
            with open(md_filepath, 'r', encoding='utf-8') as f:
                for line in f:
                    stripped = line.strip()
                    if stripped.startswith("## "):
                        themes.append(stripped[3:].strip())
        else:
            themes.extend(["Grass", "Poison", "Healing", "Heavy"]) # Fallback

        self.theme_combo.addItems(themes)

    def on_generate_clicked(self):
        map_id = self.map_id_spin.value()
        floor_num = self.floor_spin.value()
        theme = self.theme_combo.currentText()
        if theme == "Random":
            import random
            # Get all items except 'Random'
            available_themes = [self.theme_combo.itemText(i) for i in range(self.theme_combo.count()) if self.theme_combo.itemText(i) != "Random"]
            if available_themes:
                theme = random.choice(available_themes)
            else:
                theme = "Grass" # Ultimate fallback

        pbs_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', 'PBS'))
        if not os.path.exists(pbs_dir):
            self.log("Error: 'PBS' directory not found. Are you running this from the repo root?")
            return

        self.log(f"--- Starting generation for Map {map_id}, Floor {floor_num}, Theme {theme} ---")

        try:
            # Generate Metadata
            append_map_metadata(map_id, theme=theme, pbs_dir=pbs_dir)
            self.log(f"✓ Map Metadata generated/appended.")

            # Generate Encounters (Version corresponds to Floor - 1 for simplicity here, or just 0, 1, 2)
            version = floor_num - 1 if floor_num > 1 else 0
            generate_encounters(map_id, version, floor_num, theme, pbs_dir=pbs_dir)
            self.log(f"✓ Encounters generated for Map {map_id}, Version {version}.")

            # Generate Trainers (Usually you'd loop this based on map size, just doing 1 for proof of concept)
            generate_trainers(floor_num, theme, pbs_dir=pbs_dir)
            self.log(f"✓ Dynamic Trainer generated for Floor {floor_num}.")

        except Exception as e:
            self.log(f"Error during generation: {e}")

        self.log("--- Generation Complete ---")


def main():
    app = QApplication(sys.argv)
    window = PBSGeneratorApp()
    window.show()
    sys.exit(app.exec())

if __name__ == "__main__":
    main()
