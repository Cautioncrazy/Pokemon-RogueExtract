#===============================================================================
# Start Menu UI Overrides (Pause Menu)
#===============================================================================

# Remove the standard "Quit Game" option explicitly before re-adding
MenuHandlers.remove(:pause_menu, :quit_game)

# Override the standard "Quit Game" option to prevent mid-dungeon soft resets
MenuHandlers.add(:pause_menu, :quit_game, {
  "name"      => _INTL("Quit Game"),
  "order"     => 90,
  "condition" => proc { next !$game_system || !$game_system.save_disabled },
  "effect"    => proc { |menu|
    menu.pbHideMenu
    if pbConfirmMessage(_INTL("Are you sure you want to quit the game?"))
      scene = PokemonSave_Scene.new
      screen = PokemonSaveScreen.new(scene)
      screen.pbSaveScreen
      menu.pbEndScene
      $scene = nil
      next true
    end
    menu.pbRefresh
    menu.pbShowMenu
    next false
  }
})

# Add "Bounties" option to view the Quest UI directly from the Pause Menu
MenuHandlers.add(:pause_menu, :bounties, {
  "name"      => _INTL("Bounties"),
  "order"     => 35, # Places it right after standard options like Bag/Pokemon
  "condition" => proc { next $PokemonGlobal && $PokemonGlobal.quests && $PokemonGlobal.quests.active_quests.length > 0 },
  "effect"    => proc { |menu|
    pbPlayDecisionSE
    pbViewQuests
    next false
  }
})
