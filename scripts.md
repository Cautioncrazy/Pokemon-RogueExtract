Pokémon Rogue Extract - Core Scripts Reference



AI ASSISTANT DIRECTIVE (JULES):

The core engine scripts for this Pokémon Essentials v21.1 project have been extracted into individual Ruby files for version control and reference.



Script Directory Path:



Pokemon-RogueExtract\\Data\\Scripts\\



Assistant Responsibilities:



Foundation First: These extracted scripts are the foundation stones of the game. Whenever you are tasked with modifying core battle logic, map generation, UI elements, or item handling, you must reference the native architecture found within this directory to ensure compatibility.



Method Overriding vs. Editing: When implementing new features (like the Secure Pouch or Dynamic Trainer logic), prefer creating standalone plugin scripts or safely aliasing existing methods rather than destructively overwriting massive chunks of the core extracted scripts, unless explicitly instructed otherwise.



Syntax Adherence: Always match the coding style, variable naming conventions (e.g., $Trainer, $game\_map, pbMessage), and standard RGSS standard practices found within these base files.

### Known API Changes & Common Pitfalls (v21.1)

Whenever you encounter a scripting issue and identify the proper v21.1 solution, document it here for future reference:

*   **Numeric Input (`pbMessageChooseNumber`)**: In v21.1, you cannot pass a raw integer (like `999`) as the max-digits parameter to `pbMessageChooseNumber`. Doing so will cause a `NoMethodError` on `messageSkin`. You must pass a properly instantiated `ChooseNumberParams` object instead.
    ```ruby
    params = ChooseNumberParams.new
    params.setMaxDigits(3)
    params.setInitialValue(100) # Optional
    selected_number = pbMessageChooseNumber("Enter a number:", params)
    ```
