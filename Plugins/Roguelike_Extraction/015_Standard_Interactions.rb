#===============================================================================
# Standard Floor Interactions
# Helper methods to eliminate multi-line eval() strings from procedural map events.
# This strictly resolves JoiPlay EventScriptError crashes on standard encounters.
#===============================================================================

module RoguelikeExtraction
  class << self

    def safe_interaction
      begin
        yield
      rescue Exception => e
        error_msg = "=== EVENT SCRIPT CRASH (Standard Interaction) ===\n"
        error_msg += e.message + "\n"
        error_msg += e.backtrace.join("\n") if e.backtrace
        error_msg += "\n\n"
        begin
          File.open("joiplay_crash_log.txt", "a") { |f| f.puts(error_msg) }
        rescue
        end
        pbMessage(_INTL("CRASH CAUGHT! Check joiplay_crash_log.txt")) rescue nil
      end
    end

    def vip_interaction
      safe_interaction { pbDynamicTrainer("A") }
    end

    def boss_pkmn_interaction
      safe_interaction { pbDynamicBossPokemon }
    end

    def extract_interaction
      safe_interaction { pbEarlyExtractPrompt }
    end

    def trader_interaction
      safe_interaction { pbBlackMarketTrader }
    end

    def trainer_interaction
      safe_interaction { pbDynamicTrainer("A") }
    end

    def chest_interaction
      safe_interaction { pbDynamicChestLoot }
    end

    def statue_interaction(switch_id)
      safe_interaction do
        pbSet(switch_id, true)
        pbMessage(_INTL("A Rift energy pulses..."))
      end
    end

  end
end
