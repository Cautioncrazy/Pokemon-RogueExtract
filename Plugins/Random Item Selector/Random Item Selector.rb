#===============================================================================
# ** Random Item Selector
#    This plugin provides functions to choose a random item from the game's
#    item data, with options for white-listing, black-listing, and
#    excluding items based on their defined flags in items.txt.
#    Compatible with Pokémon Essentials v21.1.
#===============================================================================

# Main function to choose a random item
#
# @param whiteList     [Array<Symbol>, nil] An array of item IDs (Symbols) to
#                                           choose ONLY from. If nil, considers
#                                           all items (filtered by blackList/flags).
# @param blackList     [Array<Symbol>, String, nil] An array of item IDs to
#                                           EXCLUDE, or "nuzlocke" to use default bans.
# @param exclude_flags [Array<Symbol>, nil] An array of item flags (Symbols)
#                                           whose items should be excluded.
#                                           e.g., [:TR, :HM, :KeyItem, :PokeBall]
# @param include_pockets [Array<Integer>, nil] An array of pocket numbers to
#                                             restrict the selection to.
#                                             e.g., [1, 2] for general items.
# @return [Symbol, nil] The ID of the randomly chosen item, or nil if no item
#                       could be chosen based on the criteria.
def pbChooseRandomItem(whiteList = nil, blackList = nil, exclude_flags = nil, include_pockets = nil)
  
  # Method 2: If no blacklist is provided, or the user types "nuzlocke", fetch the banned array
  if blackList.nil? || blackList == "nuzlocke"
    blackList = getNuzlockeBannedItems
  end

  # Ensure variables are arrays if they are somehow still nil
  blackList       = [] if blackList.nil?
  exclude_flags   = [] if exclude_flags.nil?
  include_pockets = [] if include_pockets.nil?

  arr = [] # Array to store eligible item IDs

  # Process whiteList if provided
  if whiteList
    whiteList.each do |item_id|
      item_data = GameData::Item.try_get(item_id)
      next if item_data.nil?
      # Check if item is in blackList
      next if blackList.include?(item_id)
      # Check if item has any excluded flags
      next if exclude_flags.any? { |flag| item_data.has_flag?(flag) }
      # Check if item is in an included pocket (if specified)
      next if !include_pockets.empty? && !include_pockets.include?(item_data.pocket)

      arr.push(item_id)
    end
  else
    # If no whiteList, iterate through all items
    GameData::Item.each do |item_data|
      item_id = item_data.id
      # Check if item is in blackList
      next if blackList.include?(item_id)
      # Check if item has any excluded flags
      next if exclude_flags.any? { |flag| item_data.has_flag?(flag) }
      # Check if item is in an included pocket (if specified)
      next if !include_pockets.empty? && !include_pockets.include?(item_data.pocket)

      arr.push(item_id)
    end
  end

  # Pull random entry from array
  chosen_item = arr.sample
  return chosen_item
end

# Example usage function for demonstration purposes.
# This can be called from an event using `pbGiveRandomGeneralItem`
def pbGiveRandomGeneralItem
  # Define flags to exclude for "general items" (e.g., TRs/HMs, PokeBalls, KeyItems)
  excluded_flags = [:TR, :HM, :PokeBall, :KeyItem, :Berry, :Apricorn, :Mail, :TypeGem]
  
  # Define pockets to include (e.g., Pocket 1 for general items, Pocket 2 for medicine)
  included_pockets = [1, 2, 7] 

  # Tell the function to use the nuzlocke helper method
  blacklisted_items = "nuzlocke"

  # Choose a random item
  item_id = pbChooseRandomItem(
    nil,                # No whitelist, consider all (filtered)
    blacklisted_items,  # Apply specific blacklist (calls the nuzlocke helper)
    excluded_flags,     # Apply flag-based exclusions
    included_pockets    # Restrict to these pockets
  )

  if item_id
    # Use pbReceiveItem for proper messaging and bag handling
    pbReceiveItem(item_id)
  else
    pbMessage(_INTL("No suitable item could be found!"))
  end
end

# The Helper Method
def getNuzlockeBannedItems
  return [:REVIVE, :MAXREVIVE, :REVIVALHERB, :MAXHONEY, :SACREDASH]
end