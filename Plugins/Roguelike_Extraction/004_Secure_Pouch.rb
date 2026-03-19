#===============================================================================
# Secure Pouch & Hardcore Mode Settings
#===============================================================================

module RoguelikeExtraction
  # The Game Switch ID that toggles Hardcore Mode.
  # When ON, a blackout wipes the entire bag (except Key Items).
  # When OFF (Standard), a blackout reverts the bag to the start of the current floor.
  HARDCORE_MODE_SWITCH = 100

  # The starting capacity of the Secure Pouch (measured in slots/stacks).
  # You can increase this globally or dynamically via events later.
  SECURE_POUCH_START_CAPACITY = 2
end

#===============================================================================
# Secure Pouch UI & Key Item Handler
#===============================================================================
# Allows the player to open their Secure Pouch from the Bag to deposit or
# withdraw items. Items in this Pouch persist across save files and bypass
# the Blackout wipe mechanics entirely.
#===============================================================================

module RoguelikeExtraction
  def self.open_secure_pouch
    loop do
      # Calculate current capacity usage
      current_slots_used = $PokemonGlobal.secure_pouch_items.length
      max_slots = $PokemonGlobal.secure_pouch_capacity

      # Build the command window choices
      commands = []

      # Show the items currently in the Pouch
      $PokemonGlobal.secure_pouch_items.each do |slot|
        item_id = slot[0]
        qty = slot[1]
        item_name = GameData::Item.get(item_id).name
        commands.push("#{item_name} x#{qty}")
      end

      # Add standard options
      commands.push("[Deposit Item] (#{current_slots_used}/#{max_slots} slots)")
      commands.push("Cancel")

      # Prompt the player
      choice = pbMessage(_INTL("Secure Pouch: Protect items from Blackout."), commands, -1)

      # Handle Cancel or B button
      break if choice == -1 || choice == commands.length - 1

      # Handle Deposit
      if choice == commands.length - 2
        deposit_item_to_pouch
      else
        # Handle Withdraw (they selected a specific item from the pouch)
        withdraw_item_from_pouch(choice)
      end
    end
  end

  def self.deposit_item_to_pouch
    # Open the standard Bag screen in "Choose Item" mode
    item = nil
    pbFadeOutIn do
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene, $PokemonBag)
      item = screen.pbChooseItemScreen
    end

    return if !item

    # Check if item is valid to deposit
    item_data = GameData::Item.get(item)
    if item_data.is_key_item?
      pbMessage(_INTL("Key Items are already safe and cannot be deposited."))
      return
    end

    # Check capacity limit BEFORE asking for quantity
    existing_slot = $PokemonGlobal.secure_pouch_items.find { |s| s[0] == item }
    if !existing_slot && $PokemonGlobal.secure_pouch_items.length >= $PokemonGlobal.secure_pouch_capacity
      pbMessage(_INTL("Your Secure Pouch cannot hold any more unique items!"))
      return
    end

    # Check quantity to deposit
    max_qty = $PokemonBag.pbQuantity(item)
    qty_to_deposit = 1

    if max_qty > 1
      params = ChooseNumberParams.new
      params.setRange(1, max_qty)
      params.setDefaultValue(1)
      qty_to_deposit = pbMessageChooseNumber(_INTL("How many {1} would you like to deposit?", item_data.name), params)
    end

    return if qty_to_deposit <= 0

    # Store in pouch
    if existing_slot
      existing_slot[1] += qty_to_deposit
    else
      $PokemonGlobal.secure_pouch_items.push([item, qty_to_deposit])
    end

    # Remove from bag
    # Note: Because we aliased pbDeleteItem in 003_Raid_Tracker.rb,
    # this automatically deducts the quantity from the raid_bag_snapshot as well!
    # This natively prevents the Duplication Exploit on Blackout without redundant code here.
    $PokemonBag.pbDeleteItem(item, qty_to_deposit)

    pbMessage(_INTL("{1} {2} secured.", qty_to_deposit, item_data.name))
  end

  def self.withdraw_item_from_pouch(index)
    slot = $PokemonGlobal.secure_pouch_items[index]
    return if !slot

    item = slot[0]
    qty = slot[1]
    item_data = GameData::Item.get(item)

    qty_to_withdraw = 1
    if qty > 1
      params = ChooseNumberParams.new
      params.setRange(1, qty)
      params.setDefaultValue(1)
      qty_to_withdraw = pbMessageChooseNumber(_INTL("How many {1} would you like to withdraw?", item_data.name), params)
    end

    return if qty_to_withdraw <= 0

    # Add to bag
    if $PokemonBag.pbCanStore?(item, qty_to_withdraw)
      $PokemonBag.pbStoreItem(item, qty_to_withdraw)

      # Remove from pouch
      slot[1] -= qty_to_withdraw
      if slot[1] <= 0
        $PokemonGlobal.secure_pouch_items.delete_at(index)
      end

      pbMessage(_INTL("Withdrew {1} {2}.", qty_to_withdraw, item_data.name))
    else
      pbMessage(_INTL("Your Bag is too full."))
    end
  end
end

# Register the Key Item handler
ItemHandlers::UseFromBag.add(:SECUREPOUCH, proc { |item|
  # We return 2 so that after the player exits the Pouch UI, the parent
  # standard Bag UI will also automatically close, preventing them from
  # returning to a confusing nested menu state.
  RoguelikeExtraction.open_secure_pouch
  next 2
})
