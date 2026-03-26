import sys
import os
from PyQt6.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
                             QLabel, QLineEdit, QPushButton, QComboBox, QSpinBox,
                             QTextEdit, QFrame, QGridLayout, QCheckBox, QProgressBar)
from PyQt6.QtCore import Qt, QThread, pyqtSignal
from PyQt6.QtGui import QFont, QColor, QPalette

# Add the tools directory to the python path so it can be run standalone easily
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..')))

from tools.pbs_generator.map_metadata_gen import append_map_metadata
from tools.pbs_generator.encounter_gen import generate_encounters
from tools.pbs_generator.trainer_gen import generate_trainers
from tools.pbs_generator.theme_data import get_all_available_themes, get_filter_categories, get_filter_values_for_category

class GeneratorThread(QThread):
    log_signal = pyqtSignal(str)
    map_progress_signal = pyqtSignal(int)
    total_progress_signal = pyqtSignal(int)
    finished_signal = pyqtSignal()

    def __init__(self, start_map, end_map, num_floors, theme_selection, apply_theme_all, available_themes,
                 min_step_chance, max_step_chance, step_chance_chunk,
                 filter_category, filter_value, apply_filter_trainers, pbs_dir):
        super().__init__()
        self.start_map = start_map
        self.end_map = end_map
        self.num_floors = num_floors
        self.theme_selection = theme_selection
        self.apply_theme_all = apply_theme_all
        self.available_themes = available_themes
        self.min_step_chance = min_step_chance
        self.max_step_chance = max_step_chance
        self.step_chance_chunk = step_chance_chunk
        self.filter_category = filter_category
        self.filter_value = filter_value
        self.apply_filter_trainers = apply_filter_trainers
        self.pbs_dir = pbs_dir

    def run(self):
        import random
        try:
            total_maps = (self.end_map - self.start_map) + 1
            if total_maps <= 0:
                self.log_signal.emit("Error: End Map ID must be greater than or equal to Start Map ID.")
                self.finished_signal.emit()
                return

            total_iterations = total_maps * self.num_floors
            current_iteration = 0

            self.log_signal.emit(f"--- Starting Bulk Generation (Maps {self.start_map}-{self.end_map}, {self.num_floors} Floors) ---")

            for map_idx, map_id in enumerate(range(self.start_map, self.end_map + 1)):
                self.log_signal.emit(f"\nProcessing Target Map ID: {map_id}")

                for floor_num in range(1, self.num_floors + 1):
                    # Determine theme and filter for this specific floor
                    current_filter_val = self.filter_value

                    if self.apply_theme_all:
                        if self.theme_selection == "Random":
                            current_theme = random.choice(self.available_themes) if self.available_themes else "Grass"
                        else:
                            current_theme = self.theme_selection
                    else:
                        # If "Apply Theme All" is unchecked, ALWAYS randomize the theme for every single floor,
                        # ignoring whatever specific theme might be selected in the dropdown.
                        current_theme = random.choice(self.available_themes) if self.available_themes else "Grass"

                        # Randomize the filter value as well if one is active
                        if self.filter_category != "None":
                            valid_values = get_filter_values_for_category(self.filter_category)
                            current_filter_val = random.choice(valid_values) if valid_values else self.filter_value
                        else:
                            current_filter_val = "None"

                    filter_str = f" [Filter: {self.filter_category}={current_filter_val}]" if self.filter_category != "None" else ""
                    self.log_signal.emit(f"-> Floor {floor_num} | Theme: {current_theme}{filter_str}")

                    # 1. Generate Metadata
                    append_map_metadata(map_id, theme=current_theme, pbs_dir=self.pbs_dir)

                    # Calculate step chance for this floor based on chunks
                    current_chunk = (floor_num - 1) // self.step_chance_chunk
                    total_chunks = max(1, (self.num_floors - 1) // self.step_chance_chunk)
                    # Linearly interpolate between min and max based on the current chunk
                    step_chance = self.min_step_chance + int(current_chunk * (self.max_step_chance - self.min_step_chance) / total_chunks)

                    # 2. Generate Encounters
                    # Version corresponds to Floor - 1
                    version = floor_num - 1 if floor_num > 1 else 0
                    encounters_written = generate_encounters(map_id, version, floor_num, current_theme,
                                                             pbs_dir=self.pbs_dir, step_chance=step_chance,
                                                             filter_category=self.filter_category,
                                                             filter_value=current_filter_val)

                    # 3. Generate Trainers
                    t_filter_cat = self.filter_category if self.apply_filter_trainers else "None"
                    t_filter_val = current_filter_val if self.apply_filter_trainers else "None"

                    trainers_written = generate_trainers(floor_num, current_theme,
                                                         pbs_dir=self.pbs_dir,
                                                         filter_category=t_filter_cat,
                                                         filter_value=t_filter_val)

                    # Update Progress
                    current_iteration += 1
                    map_progress = int((floor_num / self.num_floors) * 100)
                    total_progress = int((current_iteration / total_iterations) * 100)

                    self.map_progress_signal.emit(map_progress)
                    self.total_progress_signal.emit(total_progress)

            self.log_signal.emit("\n--- Bulk Generation Complete! ---")

        except Exception as e:
            self.log_signal.emit(f"Error during bulk generation: {e}")

        finally:
            self.finished_signal.emit()


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

        # Start Map ID Input
        control_layout.addWidget(QLabel("Start Map ID:"), 0, 0)
        self.start_map_spin = QSpinBox()
        self.start_map_spin.setRange(1, 999)
        self.start_map_spin.setValue(100)
        control_layout.addWidget(self.start_map_spin, 0, 1)

        # End Map ID Input
        control_layout.addWidget(QLabel("End Map ID:"), 1, 0)
        self.end_map_spin = QSpinBox()
        self.end_map_spin.setRange(1, 999)
        self.end_map_spin.setValue(100)
        control_layout.addWidget(self.end_map_spin, 1, 1)

        # Floor Number (Versions)
        control_layout.addWidget(QLabel("Number of Floors:"), 2, 0)
        self.num_floors_spin = QSpinBox()
        self.num_floors_spin.setRange(1, 999)
        self.num_floors_spin.setValue(1)
        control_layout.addWidget(self.num_floors_spin, 2, 1)

        # Theme Selection
        control_layout.addWidget(QLabel("Floor Theme:"), 3, 0)
        self.theme_combo = QComboBox()
        self.populate_themes()
        control_layout.addWidget(self.theme_combo, 3, 1)

        # Step Chance Parameters
        control_layout.addWidget(QLabel("Min Step Chance (%):"), 4, 0)
        self.min_step_spin = QSpinBox()
        self.min_step_spin.setRange(1, 100)
        self.min_step_spin.setValue(5)
        control_layout.addWidget(self.min_step_spin, 4, 1)

        control_layout.addWidget(QLabel("Max Step Chance (%):"), 5, 0)
        self.max_step_spin = QSpinBox()
        self.max_step_spin.setRange(1, 100)
        self.max_step_spin.setValue(20)
        control_layout.addWidget(self.max_step_spin, 5, 1)

        control_layout.addWidget(QLabel("Step Chance Chunk:"), 6, 0)
        self.step_chunk_spin = QSpinBox()
        self.step_chunk_spin.setRange(1, 999)
        self.step_chunk_spin.setValue(5)
        self.step_chunk_spin.setToolTip("Floors are grouped into chunks for step chance calculation.")
        control_layout.addWidget(self.step_chunk_spin, 6, 1)

        # Index Filter Options
        control_layout.addWidget(QLabel("Index Filter Category:"), 7, 0)
        self.filter_category_combo = QComboBox()
        self.filter_category_combo.addItems(get_filter_categories())
        self.filter_category_combo.currentTextChanged.connect(self.on_filter_category_changed)
        control_layout.addWidget(self.filter_category_combo, 7, 1)

        control_layout.addWidget(QLabel("Index Filter Value:"), 8, 0)
        self.filter_value_combo = QComboBox()
        control_layout.addWidget(self.filter_value_combo, 8, 1)
        self.on_filter_category_changed(self.filter_category_combo.currentText())

        # Apply Filter to Trainers Checkbox
        self.apply_filter_trainers_cb = QCheckBox("Apply Filter to Trainers")
        self.apply_filter_trainers_cb.setStyleSheet("color: white; font-size: 13px; background-color: transparent;")
        self.apply_filter_trainers_cb.setChecked(True)
        control_layout.addWidget(self.apply_filter_trainers_cb, 9, 0, 1, 2)

        # Apply Theme to All Checkbox
        self.apply_theme_all_cb = QCheckBox("Apply Selected Theme to All Maps")
        self.apply_theme_all_cb.setStyleSheet("color: white; font-size: 13px; background-color: transparent;")
        control_layout.addWidget(self.apply_theme_all_cb, 10, 0, 1, 2)

        # Generate Button
        self.generate_btn = QPushButton("Generate Bulk Data")
        self.generate_btn.clicked.connect(self.on_generate_clicked)
        control_layout.addWidget(self.generate_btn, 11, 0, 1, 2)

        # Progress Bars
        self.map_progress_bar = QProgressBar()
        self.map_progress_bar.setFormat("Current Map Progress: %p%")
        self.map_progress_bar.setValue(0)
        self.map_progress_bar.setStyleSheet("""
            QProgressBar {
                background-color: rgba(0, 0, 0, 0.3);
                color: white;
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 5px;
                text-align: center;
            }
            QProgressBar::chunk {
                background-color: #4da6ff;
                border-radius: 4px;
            }
        """)
        control_layout.addWidget(self.map_progress_bar, 12, 0, 1, 2)

        self.total_progress_bar = QProgressBar()
        self.total_progress_bar.setFormat("Total Batch Progress: %p%")
        self.total_progress_bar.setValue(0)
        self.total_progress_bar.setStyleSheet("""
            QProgressBar {
                background-color: rgba(0, 0, 0, 0.3);
                color: white;
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 5px;
                text-align: center;
            }
            QProgressBar::chunk {
                background-color: #ff9933;
                border-radius: 4px;
            }
        """)
        control_layout.addWidget(self.total_progress_bar, 13, 0, 1, 2)

        main_layout.addWidget(control_panel)

        # Log Output Console
        self.log_console = QTextEdit()
        self.log_console.setReadOnly(True)
        self.log_console.setPlaceholderText("Generation logs will appear here...")
        main_layout.addWidget(self.log_console)

    def log(self, message):
        self.log_console.append(message)

    def on_filter_category_changed(self, category):
        self.filter_value_combo.clear()
        if category == "None":
            self.filter_value_combo.addItem("None")
            self.filter_value_combo.setEnabled(False)
        else:
            values = get_filter_values_for_category(category)
            self.filter_value_combo.addItems(values)
            self.filter_value_combo.setEnabled(True)

    def populate_themes(self):
        md_themes = []
        md_filepath = os.path.abspath(os.path.join(os.path.dirname(__file__), 'encounters.md'))
        if os.path.exists(md_filepath):
            with open(md_filepath, 'r', encoding='utf-8') as f:
                for line in f:
                    stripped = line.strip()
                    if stripped.startswith("## "):
                        md_themes.append(stripped[3:].strip())

        themes = ["Random"] + get_all_available_themes(md_themes=md_themes)

        self.theme_combo.addItems(themes)

    def on_generate_clicked(self):
        start_map = self.start_map_spin.value()
        end_map = self.end_map_spin.value()
        num_floors = self.num_floors_spin.value()
        theme_selection = self.theme_combo.currentText()
        apply_theme_all = self.apply_theme_all_cb.isChecked()
        min_step_chance = self.min_step_spin.value()
        max_step_chance = self.max_step_spin.value()
        step_chance_chunk = self.step_chunk_spin.value()
        filter_category = self.filter_category_combo.currentText()
        filter_value = self.filter_value_combo.currentText()
        apply_filter_trainers = self.apply_filter_trainers_cb.isChecked()

        # Get list of valid themes (excluding "Random")
        available_themes = [self.theme_combo.itemText(i) for i in range(self.theme_combo.count()) if self.theme_combo.itemText(i) != "Random"]

        pbs_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', 'PBS'))
        if not os.path.exists(pbs_dir):
            self.log("Error: 'PBS' directory not found. Are you running this from the repo root?")
            return

        # Disable UI during generation
        self.generate_btn.setEnabled(False)
        self.start_map_spin.setEnabled(False)
        self.end_map_spin.setEnabled(False)
        self.num_floors_spin.setEnabled(False)
        self.theme_combo.setEnabled(False)
        self.apply_theme_all_cb.setEnabled(False)
        self.min_step_spin.setEnabled(False)
        self.max_step_spin.setEnabled(False)
        self.step_chunk_spin.setEnabled(False)
        self.filter_category_combo.setEnabled(False)
        self.filter_value_combo.setEnabled(False)
        self.apply_filter_trainers_cb.setEnabled(False)

        self.map_progress_bar.setValue(0)
        self.total_progress_bar.setValue(0)

        # Start background thread
        self.thread = GeneratorThread(
            start_map=start_map,
            end_map=end_map,
            num_floors=num_floors,
            theme_selection=theme_selection,
            apply_theme_all=apply_theme_all,
            available_themes=available_themes,
            min_step_chance=min_step_chance,
            max_step_chance=max_step_chance,
            step_chance_chunk=step_chance_chunk,
            filter_category=filter_category,
            filter_value=filter_value,
            apply_filter_trainers=apply_filter_trainers,
            pbs_dir=pbs_dir
        )

        self.thread.log_signal.connect(self.log)
        self.thread.map_progress_signal.connect(self.map_progress_bar.setValue)
        self.thread.total_progress_signal.connect(self.total_progress_bar.setValue)
        self.thread.finished_signal.connect(self.on_generation_finished)

        self.thread.start()

    def on_generation_finished(self):
        # Re-enable UI
        self.generate_btn.setEnabled(True)
        self.start_map_spin.setEnabled(True)
        self.end_map_spin.setEnabled(True)
        self.num_floors_spin.setEnabled(True)
        self.theme_combo.setEnabled(True)
        self.apply_theme_all_cb.setEnabled(True)
        self.min_step_spin.setEnabled(True)
        self.max_step_spin.setEnabled(True)
        self.step_chunk_spin.setEnabled(True)
        self.filter_category_combo.setEnabled(True)
        # Only re-enable value combo if category is not "None"
        if self.filter_category_combo.currentText() != "None":
            self.filter_value_combo.setEnabled(True)
        self.apply_filter_trainers_cb.setEnabled(True)


def main():
    app = QApplication(sys.argv)
    window = PBSGeneratorApp()
    window.show()
    sys.exit(app.exec())

if __name__ == "__main__":
    main()
