#===============================================================================
# Bounty Board Logic (Quest System)
#===============================================================================

# To be placed inside the Bounty Board event in the Hub
def pbBountyBoard
  pbMessage(_INTL("Bounty Board\\nAvailable contracts for Extraction Runs."))

  max_floor = $game_variables[100] || 0

  loop do
    commands = [
      _INTL("View Bounties"),
      _INTL("Accept Slayer"),
      _INTL("Accept Gatherer"),
      _INTL("Accept Survivor"),
      _INTL("Cancel")
    ]

    choice = pbMessage(_INTL("What would you like to do?"), commands, -1)

    break if choice < 0 || choice == commands.length - 1

    if choice == 0
      # View Quest UI
      pbViewQuests
    elsif choice == 1
      # Slayer Bounty
      if $PokemonGlobal.quests.active_quests.any? { |q| q.id == :Quest1 }
        pbMessage(_INTL("You have already accepted the Slayer bounty."))
      elsif $PokemonGlobal.quests.completed_quests.any? { |q| q.id == :Quest1 }
        pbMessage(_INTL("You have already completed the Slayer bounty."))
      else
        pbMessage(_INTL("Bounty accepted: Slayer.\\nDefeat 5 VIP/Boss Trainers in runs."))
        activateQuest(:Quest1)
        $game_variables[101] = 0 # Track Slayer bosses defeated
      end
    elsif choice == 2
      # Gatherer Bounty
      if $PokemonGlobal.quests.active_quests.any? { |q| q.id == :Quest2 }
        pbMessage(_INTL("You have already accepted the Gatherer bounty."))
      elsif $PokemonGlobal.quests.completed_quests.any? { |q| q.id == :Quest2 }
        pbMessage(_INTL("You have already completed the Gatherer bounty."))
      else
        if max_floor >= 5
          pbMessage(_INTL("Bounty accepted: Gatherer.\\nMine 10 Hollowed Souls."))
          activateQuest(:Quest2)
          $game_variables[102] = 0 # Track Hollowed Souls mined
        else
          pbMessage(_INTL("This bounty requires reaching Floor 5 first."))
        end
      end
    elsif choice == 3
      # Survivor Bounty
      if $PokemonGlobal.quests.active_quests.any? { |q| q.id == :Quest3 }
        pbMessage(_INTL("You have already accepted the Survivor bounty."))
      elsif $PokemonGlobal.quests.completed_quests.any? { |q| q.id == :Quest3 }
        pbMessage(_INTL("You have already completed the Survivor bounty."))
      else
        if max_floor >= 10
          pbMessage(_INTL("Bounty accepted: Survivor.\\nReach Floor 20 in a single run."))
          activateQuest(:Quest3)
        else
          pbMessage(_INTL("This bounty requires reaching Floor 10 first."))
        end
      end
    end
  end
end
