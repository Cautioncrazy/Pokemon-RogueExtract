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

# Generates a static, tiered mart of general items based on progression.
def pbRaidMart
  floor = $PokemonGlobal.last_raid_floor || 0
  floor = floor.to_i

  # Completely overwrite the pool based on highest tier reached
  if floor >= 10
    pool = [:ULTRABALL, :HYPERPOTION, :FULLHEAL, :MAXREPEL, :REVIVE, :ESCAPEROPE, :FULLRESTORE, :MAXPOTION]
  elsif floor >= 5
    pool = [:GREATBALL, :SUPERPOTION, :ANTIDOTE, :PARALYZEHEAL, :SUPERREPEL, :ESCAPEROPE, :REVIVE, :FRESHWATER]
  else
    pool = [:POKEBALL, :POTION, :ANTIDOTE, :PARALYZEHEAL, :AWAKENING, :REPEL, :BURNHEAL, :ICEHEAL]
  end

  # Sort items by price to keep the mart looking clean
  pool.sort_by! { |s| GameData::Item.get(s).price }

  pbPokemonMart(pool)
end

# Generates a random mart of 4-6 TMs with a rare chance for an HM.
def pbRaidMartTM
  # Check if we already rolled a shop inventory for this Hub stay
  cached_stock = $PokemonGlobal.instance_variable_get(:@hub_tm_cache)
  if cached_stock && !cached_stock.empty?
    pbPokemonMart(cached_stock)
    return
  end

  tm_pool = []
  hm_pool = []

  GameData::Item.each do |item|
    item_id_str = item.id.to_s
    tm_pool << item.id if item_id_str.start_with?("TM")
    hm_pool << item.id if item_id_str.start_with?("HM")
  end

  num_items = rand(4..6)
  # Failsafe in case tm_pool is empty
  selected_items = tm_pool.empty? ? [] : tm_pool.sample(num_items)

  # 10% chance to add a rare HM to the stock
  if rand(100) < 10 && !hm_pool.empty?
    selected_items << hm_pool.sample
  end

  # Sort items by price
  selected_items.sort_by! { |s| GameData::Item.get(s).price } unless selected_items.empty?

  # Save the rolled inventory so it persists until the player leaves the Hub
  $PokemonGlobal.instance_variable_set(:@hub_tm_cache, selected_items)

  pbPokemonMart(selected_items)
end
