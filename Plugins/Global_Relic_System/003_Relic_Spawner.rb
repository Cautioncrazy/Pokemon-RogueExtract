#===============================================================================
# Global Relic System - Loot Spawner & 3D Printer
#===============================================================================

module RoguelikeExtraction
  RELICS_UNCOMMON = [
    :RELIC_MUSCLE,
    :RELIC_LENS,
    :RELIC_EXTENDER
  ]

  RELICS_RARE = [
    # Placeholder for rare relics later
  ]
end

# Register all relics as non-tossable regardless of debug mode or pocket
(RoguelikeExtraction::RELICS_UNCOMMON + RoguelikeExtraction::RELICS_RARE).each do |relic|
  ItemHandlers::CanToss.add(relic, proc { |item|
    pbMessage(_INTL("That's too important to toss out!"))
    next false
  })
end

class Interpreter
  # Give a random relic based on rarity
  def pbGiveRandomRelic(rarity = :UNCOMMON)
    pool = []
    case rarity
    when :UNCOMMON
      pool = RoguelikeExtraction::RELICS_UNCOMMON
    when :RARE
      pool = RoguelikeExtraction::RELICS_RARE
    end

    # Fallback to uncommon if rare pool is empty
    pool = RoguelikeExtraction::RELICS_UNCOMMON if pool.empty?

    if pool.empty?
      pbMessage(_INTL("No relics available in the pool!"))
      return false
    end

    relic_id = pool.sample
    pbReceiveItem(relic_id)
    return true
  end

  # 3D Printer Event: Can consume an existing relic to gain a specific new one
  def pb3DPrinterEvent
    # All valid relics possible to be printed or traded
    all_relics = RoguelikeExtraction::RELICS_UNCOMMON + RoguelikeExtraction::RELICS_RARE

    if all_relics.empty?
      pbMessage(_INTL("The 3D Printer seems to be broken."))
      return
    end

    # Get the specific map event ID
    event = pbMapInterpreter.get_character(0)
    return if !event

    # Use a persistent hash to save the selected item for this printer instance
    $PokemonGlobal.instance_variable_set(:@printer_items, {}) if !$PokemonGlobal.instance_variable_defined?(:@printer_items) || $PokemonGlobal.instance_variable_get(:@printer_items).nil?

    saved_printers = $PokemonGlobal.instance_variable_get(:@printer_items)

    printer_key = [$game_map.map_id, event.id]

    if saved_printers[printer_key]
      offered_relic = saved_printers[printer_key]
    else
      offered_relic = all_relics.sample
      saved_printers[printer_key] = offered_relic
    end

    relic_name = GameData::Item.get(offered_relic).name

    pbMessage(_INTL("You found a 3D Printer! It is currently configured to print: {1}.", relic_name))

    loop do
      # Find eligible owned relics (exclude the one being offered so you don't trade X for X)
      eligible_relics = []
      all_relics.each do |relic|
        next if relic == offered_relic
        qty = $bag.quantity(relic)
        if qty > 0
          # Add to array multiple times if multiple are owned, so it's a random pull of owned stack
          qty.times { eligible_relics.push(relic) }
        end
      end

      if eligible_relics.empty?
        pbMessage(_INTL("You don't have any eligible relics to feed the printer."))
        break
      end

      if pbConfirmMessage(_INTL("Feed a random owned relic to print a {1}?", relic_name))
        # Consume a random eligible relic
        consumed_relic = eligible_relics.sample
        consumed_name = GameData::Item.get(consumed_relic).name

        # Remove one consumed relic and add the printed relic
        $bag.remove(consumed_relic, 1)
        pbReceiveItem(offered_relic, 1)

        pbMessage(_INTL("You fed the printer a {1} and received a {2}!", consumed_name, relic_name))
      else
        # Player declined
        pbMessage(_INTL("You decided to leave the 3D Printer alone."))
        break
      end
    end
  end
end
