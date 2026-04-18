#===============================================================================
# Standard Floor Interactions
# Helper methods to eliminate multi-line eval() strings from procedural map events.
# This strictly resolves JoiPlay EventScriptError crashes on standard encounters.
#===============================================================================

module RoguelikeExtraction
  class << self

    def safe_interaction(interp)
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
        interp.pbMessage(_INTL("CRASH CAUGHT! Check joiplay_crash_log.txt")) rescue nil
      end
    end

    def vip_interaction(interp)
      safe_interaction(interp) { interp.pbDynamicTrainer("A") }
    end

    def boss_pkmn_interaction(interp)
      safe_interaction(interp) { interp.pbDynamicBossPokemon }
    end

    def extract_interaction(interp)
      safe_interaction(interp) { interp.pbEarlyExtractPrompt }
    end

    def trader_interaction(interp)
      safe_interaction(interp) { interp.pbBlackMarketTrader }
    end

    def trainer_interaction(interp)
      safe_interaction(interp) { interp.pbDynamicTrainer("A") }
    end

    def chest_interaction(interp)
      safe_interaction(interp) { interp.pbDynamicChestLoot }
    end

    def statue_interaction(switch_id, interp)
      safe_interaction(interp) do
        interp.pbSet(switch_id, true)
        interp.pbMessage(_INTL("A Rift energy pulses..."))
      end
    end

  end
end
