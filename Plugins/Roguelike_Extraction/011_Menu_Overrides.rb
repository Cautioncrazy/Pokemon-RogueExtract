#===============================================================================
# Start Menu UI Overrides (Pause Menu)
#===============================================================================

# Remove the standard "Quit" option to prevent mid-dungeon soft resets
MenuHandlers.remove(:pause_menu, :quit)

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
