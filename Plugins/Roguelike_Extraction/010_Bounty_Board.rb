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
      _INTL("Slayer (Repeatable)"),
      _INTL("Gatherer (Repeatable)"),
      _INTL("Survivor (Repeatable)"),
      _INTL("Apex Predator (Chain)"),
      _INTL("Cancel")
    ]

    choice = pbMessage(_INTL("What would you like to do?"), commands, -1)

    break if choice < 0 || choice == commands.length - 1

    if choice == 0
      # View Quest UI
      pbViewQuests
    elsif choice == 1
      # Slayer Bounty (Repeatable)
      if $PokemonGlobal.quests.active_quests.any? { |q| q.id == :Quest1 }
        pbMessage(_INTL("You are currently tracking the Slayer bounty."))
      elsif $PokemonGlobal.quests.completed_quests.any? { |q| q.id == :Quest1 }
        pbMessage(_INTL("You have turned in the Slayer bounty. Here is your reward!"))
        pbReceiveItem(:ITEM_HOLLOWED_SOUL, 5)
        # Reset the quest by removing it from completed
        $PokemonGlobal.quests.completed_quests.delete_if { |q| q.id == :Quest1 }
        activateQuest(:Quest1)
        $game_variables[101] = 0
        pbMessage(_INTL("The Slayer bounty has been reset and re-accepted."))
      else
        pbMessage(_INTL("Bounty accepted: Slayer.\\nDefeat 5 VIP/Boss Trainers in runs."))
        activateQuest(:Quest1)
        $game_variables[101] = 0 # Track Slayer bosses defeated
      end
    elsif choice == 2
      # Gatherer Bounty (Repeatable)
      if $PokemonGlobal.quests.active_quests.any? { |q| q.id == :Quest2 }
        pbMessage(_INTL("You are currently tracking the Gatherer bounty."))
      elsif $PokemonGlobal.quests.completed_quests.any? { |q| q.id == :Quest2 }
        pbMessage(_INTL("You have turned in the Gatherer bounty. Here is your reward!"))
        pbReceiveItem(:ARTIFACT_FORTUNE, 1)
        # Reset the quest
        $PokemonGlobal.quests.completed_quests.delete_if { |q| q.id == :Quest2 }
        activateQuest(:Quest2)
        $game_variables[102] = 0
        pbMessage(_INTL("The Gatherer bounty has been reset and re-accepted."))
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
      # Survivor Bounty (Repeatable)
      if $PokemonGlobal.quests.active_quests.any? { |q| q.id == :Quest3 }
        pbMessage(_INTL("You are currently tracking the Survivor bounty."))
      elsif $PokemonGlobal.quests.completed_quests.any? { |q| q.id == :Quest3 }
        pbMessage(_INTL("You have turned in the Survivor bounty. Here is your reward!"))
        pbReceiveItem(:ARTIFACT_VITALITY, 1)
        # Reset the quest
        $PokemonGlobal.quests.completed_quests.delete_if { |q| q.id == :Quest3 }
        activateQuest(:Quest3)
        pbMessage(_INTL("The Survivor bounty has been reset and re-accepted."))
      else
        if max_floor >= 10
          pbMessage(_INTL("Bounty accepted: Survivor.\\nReach Floor 20 in a single run."))
          activateQuest(:Quest3)
        else
          pbMessage(_INTL("This bounty requires reaching Floor 10 first."))
        end
      end
    elsif choice == 4
      # Tiered Milestone Chaining (Apex Predator)
      if $PokemonGlobal.quests.active_quests.any? { |q| q.id == :Quest6 }
        pbMessage(_INTL("You are currently tracking Apex Predator I."))
      elsif $PokemonGlobal.quests.active_quests.any? { |q| q.id == :Quest7 }
        pbMessage(_INTL("You are currently tracking Apex Predator II."))
      elsif $PokemonGlobal.quests.completed_quests.any? { |q| q.id == :Quest7 }
        pbMessage(_INTL("You have already completed the entire Apex Predator chain!"))
      elsif $PokemonGlobal.quests.completed_quests.any? { |q| q.id == :Quest6 }
        pbMessage(_INTL("You have turned in Apex Predator I! Here is your reward!"))
        pbReceiveItem(:MASTERBALL, 1)
        # Advance to next tier automatically
        pbMessage(_INTL("New tier unlocked: Apex Predator II!"))
        activateQuest(:Quest7)
        $game_variables[106] = 0 # Reusing a variable for the next tier's count, or keep 106 if it continues scaling
      else
        pbMessage(_INTL("Bounty accepted: Apex Predator I.\\nDefeat 15 VIP/Boss Trainers total."))
        activateQuest(:Quest6)
        $game_variables[106] = 0
      end
    end
  end
end
