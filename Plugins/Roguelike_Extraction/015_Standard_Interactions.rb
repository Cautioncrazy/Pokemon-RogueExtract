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
      end
    end

    def vip_interaction(interp)
      interp.pbDynamicTrainer("A")
    end

    def boss_pkmn_interaction(interp)
      interp.pbDynamicBossPokemon
    end

    def extract_interaction(interp)
      safe_interaction(interp) { interp.pbEarlyExtractPrompt }
    end

    def trader_interaction(interp)
      safe_interaction(interp) { interp.pbBlackMarketTrader }
    end

    def trainer_interaction(interp)
      interp.pbDynamicTrainer("A")
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

#===============================================================================
# Global Script Calls for Hub / Standard Events
#===============================================================================

# Generates a random mart of 6-8 general items based on progression.
def pbRaidMart
  floor = $PokemonGlobal.last_raid_floor || 0

  # Always available
  pool = [:POKEBALL, :POTION, :ANTIDOTE, :PARALYZEHEAL, :AWAKENING, :REPEL]

  # Mid-Tier
  if floor >= 5
    pool += [:GREATBALL, :SUPERPOTION, :FULLHEAL, :ESCAPEROPE]
  end

  # High-Tier
  if floor >= 10
    pool += [:ULTRABALL, :HYPERPOTION, :REVIVE, :MAXREPEL]
  end

  num_items = rand(6..8)
  selected_items = pool.sample(num_items)

  # Sort items by price to keep the mart looking clean
  selected_items.sort_by! { |s| GameData::Item.get(s).price }

  pbPokemonMart(selected_items)
end

# Generates a random mart of 4-6 TMs with a rare chance for an HM.
def pbRaidMartTM
  tm_pool = []
  hm_pool = []

  GameData::Item.each do |item|
    tm_pool << item.id if item.is_TM?
    hm_pool << item.id if item.is_HM?
  end

  num_items = rand(4..6)
  selected_items = tm_pool.sample(num_items)

  # 10% chance to add a rare HM to the stock
  if rand(100) < 10 && !hm_pool.empty?
    selected_items << hm_pool.sample
  end

  # Sort items by price to keep the mart looking clean
  selected_items.sort_by! { |s| GameData::Item.get(s).price }

  pbPokemonMart(selected_items)
end
