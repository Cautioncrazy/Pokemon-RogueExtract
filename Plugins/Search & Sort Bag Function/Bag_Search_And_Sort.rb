#==============================================================================
# Bag Search & Sort
# Adds Search and Sort functionality to the Pokémon bag screen.
# Compatible with Pokémon Essentials v21.1
# If used please give credits.
#==============================================================================

class Window_PokemonBag < Window_DrawableCommand
  attr_reader :pocket
  attr_accessor :sorting
  attr_accessor :display_filter   # search/sort overlay filter (highest priority)

  def initialize(bag, filterlist, pocket, x, y, width, height)
    @bag            = bag
    @filterlist     = filterlist
    @display_filter = nil
    @pocket         = pocket
    @sorting        = false
    @adapter        = PokemonMartAdapter.new
    super(x, y, width, height)
    @selarrow  = AnimatedBitmap.new("Graphics/UI/Bag/cursor")
    @swaparrow = AnimatedBitmap.new("Graphics/UI/Bag/cursor_swap")
    self.windowskin = nil
  end

  def dispose
    @selarrow.dispose
    @swaparrow.dispose
    super
  end

  # Returns whichever filter is currently active (display_filter > filterlist > nil)
  def active_filter
    @display_filter || @filterlist
  end

  def pocket=(value)
    @pocket = value
    af = active_filter
    @item_max = (af) ? af[@pocket].length + 1 : @bag.pockets[@pocket].length + 1
    self.index = @bag.last_viewed_index(@pocket)
  end

  def page_row_max; return PokemonBag_Scene::ITEMSVISIBLE; end
  def page_item_max; return PokemonBag_Scene::ITEMSVISIBLE; end

  def item
    af = active_filter
    return nil if af && !af[@pocket][self.index]
    thispocket = @bag.pockets[@pocket]
    item = (af) ? thispocket[af[@pocket][self.index]] : thispocket[self.index]
    return (item) ? item[0] : nil
  end

  def itemCount
    af = active_filter
    return (af) ? af[@pocket].length + 1 : @bag.pockets[@pocket].length + 1
  end

  def itemRect(item)
    if item < 0 || item >= @item_max || item < self.top_item - 1 ||
       item > self.top_item + self.page_item_max
      return Rect.new(0, 0, 0, 0)
    else
      cursor_width = (self.width - self.borderX - ((@column_max - 1) * @column_spacing)) / @column_max
      x = item % @column_max * (cursor_width + @column_spacing)
      y = (item / @column_max * @row_height) - @virtualOy
      return Rect.new(x, y, cursor_width, @row_height)
    end
  end

  def drawCursor(index, rect)
    if self.index == index
      bmp = (@sorting) ? @swaparrow.bitmap : @selarrow.bitmap
      pbCopyBitmap(self.contents, bmp, rect.x, rect.y + 2)
    end
  end

  def drawItem(index, _count, rect)
    textpos = []
    rect = Rect.new(rect.x + 16, rect.y + 16, rect.width - 16, rect.height)
    thispocket = @bag.pockets[@pocket]
    af = active_filter
    if index == self.itemCount - 1
      textpos.push([_INTL("CLOSE BAG"), rect.x, rect.y + 2, :left, self.baseColor, self.shadowColor])
    else
      item = (af) ? thispocket[af[@pocket][index]][0] : thispocket[index][0]
      baseColor   = self.baseColor
      shadowColor = self.shadowColor
      if @sorting && index == self.index
        baseColor   = Color.new(224, 0, 0)
        shadowColor = Color.new(248, 144, 144)
      end
      textpos.push(
        [@adapter.getDisplayName(item), rect.x, rect.y + 2, :left, baseColor, shadowColor]
      )
      item_data = GameData::Item.get(item)
      showing_register_icon = false
      if item_data.is_important?
        if @bag.registered?(item)
          pbDrawImagePositions(
            self.contents,
            [["Graphics/UI/Bag/icon_register", rect.x + rect.width - 72, rect.y + 8, 0, 0, -1, 24]]
          )
          showing_register_icon = true
        elsif pbCanRegisterItem?(item)
          pbDrawImagePositions(
            self.contents,
            [["Graphics/UI/Bag/icon_register", rect.x + rect.width - 72, rect.y + 8, 0, 24, -1, 24]]
          )
          showing_register_icon = true
        end
      end
      if item_data.show_quantity? && !showing_register_icon
        qty = (af) ? thispocket[af[@pocket][index]][1] : thispocket[index][1]
        qtytext = _ISPRINTF("x{1: 3d}", qty)
        xQty    = rect.x + rect.width - self.contents.text_size(qtytext).width - 16
        textpos.push([qtytext, xQty, rect.y + 2, :left, baseColor, shadowColor])
      end
    end
    pbDrawTextPositions(self.contents, textpos)
  end

  def refresh
    @item_max = itemCount
    self.update_cursor_rect
    dwidth  = self.width - self.borderX
    dheight = self.height - self.borderY
    self.contents = pbDoEnsureBitmap(self.contents, dwidth, dheight)
    self.contents.clear
    @item_max.times do |i|
      next if i < self.top_item - 1 || i > self.top_item + self.page_item_max
      drawItem(i, @item_max, itemRect(i))
    end
    drawCursor(self.index, itemRect(self.index))
  end

  def update
    super
    @uparrow.visible   = false
    @downarrow.visible = false
  end
end

#===============================================================================
# Bag visuals
#===============================================================================
class PokemonBag_Scene
  ITEMLISTBASECOLOR     = Color.new(88, 88, 80)
  ITEMLISTSHADOWCOLOR   = Color.new(168, 184, 184)
  ITEMTEXTBASECOLOR     = Color.new(248, 248, 248)
  ITEMTEXTSHADOWCOLOR   = Color.new(0, 0, 0)
  POCKETNAMEBASECOLOR   = Color.new(88, 88, 80)
  POCKETNAMESHADOWCOLOR = Color.new(168, 184, 184)
  ITEMSVISIBLE          = 7

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene(bag, choosing = false, filterproc = nil, resetpocket = true)
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @bag        = bag
    @choosing   = choosing
    @filterproc = filterproc
    @search_text    = nil
    @display_filter = nil
    pbRefreshFilter
    lastpocket = @bag.last_viewed_pocket
    numfilledpockets = @bag.pockets.length - 1
    if @choosing
      numfilledpockets = 0
      if @filterlist.nil?
        (1...@bag.pockets.length).each do |i|
          numfilledpockets += 1 if @bag.pockets[i].length > 0
        end
      else
        (1...@bag.pockets.length).each do |i|
          numfilledpockets += 1 if @filterlist[i].length > 0
        end
      end
      lastpocket = (resetpocket) ? 1 : @bag.last_viewed_pocket
      if (@filterlist && @filterlist[lastpocket].length == 0) ||
         (!@filterlist && @bag.pockets[lastpocket].length == 0)
        (1...@bag.pockets.length).each do |i|
          if @filterlist && @filterlist[i].length > 0
            lastpocket = i
            break
          elsif !@filterlist && @bag.pockets[i].length > 0
            lastpocket = i
            break
          end
        end
      end
    end
    @bag.last_viewed_pocket = lastpocket
    @sliderbitmap = AnimatedBitmap.new("Graphics/UI/Bag/icon_slider")
    @pocketbitmap = AnimatedBitmap.new("Graphics/UI/Bag/icon_pocket")
    @sprites = {}
    @sprites["background"] = IconSprite.new(0, 0, @viewport)
    @sprites["overlay"]    = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["bagsprite"]  = IconSprite.new(30, 20, @viewport)
    @sprites["pocketicon"] = BitmapSprite.new(186, 32, @viewport)
    @sprites["pocketicon"].x = 0
    @sprites["pocketicon"].y = 224
    @sprites["leftarrow"] = AnimatedSprite.new("Graphics/UI/left_arrow", 8, 40, 28, 2, @viewport)
    @sprites["leftarrow"].x       = -4
    @sprites["leftarrow"].y       = 76
    @sprites["leftarrow"].visible = (!@choosing || numfilledpockets > 1)
    @sprites["leftarrow"].play
    @sprites["rightarrow"] = AnimatedSprite.new("Graphics/UI/right_arrow", 8, 40, 28, 2, @viewport)
    @sprites["rightarrow"].x       = 150
    @sprites["rightarrow"].y       = 76
    @sprites["rightarrow"].visible = (!@choosing || numfilledpockets > 1)
    @sprites["rightarrow"].play
    @sprites["itemlist"] = Window_PokemonBag.new(@bag, @filterlist, lastpocket, 168, -8, 314, 40 + 32 + (ITEMSVISIBLE * 32))
    @sprites["itemlist"].viewport    = @viewport
    @sprites["itemlist"].pocket      = lastpocket
    @sprites["itemlist"].index       = @bag.last_viewed_index(lastpocket)
    @sprites["itemlist"].baseColor   = ITEMLISTBASECOLOR
    @sprites["itemlist"].shadowColor = ITEMLISTSHADOWCOLOR
    @sprites["itemicon"] = ItemIconSprite.new(48, Graphics.height - 48, nil, @viewport)
    @sprites["itemtext"] = Window_UnformattedTextPokemon.newWithSize(
      "", 72, 272, Graphics.width - 72 - 24, 128, @viewport
    )
    @sprites["itemtext"].baseColor   = ITEMTEXTBASECOLOR
    @sprites["itemtext"].shadowColor = ITEMTEXTSHADOWCOLOR
    @sprites["itemtext"].visible     = true
    @sprites["itemtext"].windowskin  = nil
    @sprites["helpwindow"] = Window_UnformattedTextPokemon.new("")
    @sprites["helpwindow"].visible  = false
    @sprites["helpwindow"].viewport = @viewport
    @sprites["msgwindow"] = Window_AdvancedTextPokemon.new("")
    @sprites["msgwindow"].visible  = false
    @sprites["msgwindow"].viewport = @viewport
    pbBottomLeftLines(@sprites["helpwindow"], 1)
    pbDeactivateWindows(@sprites)
    pbRefresh
    pbFadeInAndShow(@sprites)
  end

  def pbFadeOutScene
    @oldsprites = pbFadeOutAndHide(@sprites)
  end

  def pbFadeInScene
    pbFadeInAndShow(@sprites, @oldsprites)
    @oldsprites = nil
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) if !@oldsprites
    @oldsprites = nil
    dispose
  end

  def dispose
    @viewport.dispose
    pbDisposeSpriteHash(@sprites)
    @sliderbitmap.dispose
    @pocketbitmap.dispose
  end

  def pbDisplay(msg, brief = false)
    UIHelper.pbDisplay(@sprites["msgwindow"], msg, brief) { pbUpdate }
  end

  def pbConfirm(msg)
    UIHelper.pbConfirm(@sprites["msgwindow"], msg) { pbUpdate }
  end

  def pbChooseNumber(helptext, maximum, initnum = 1)
    return UIHelper.pbChooseNumber(@sprites["helpwindow"], helptext, maximum, initnum) { pbUpdate }
  end

  def pbShowCommands(helptext, commands, index = 0)
    return UIHelper.pbShowCommands(@sprites["helpwindow"], helptext, commands, index) { pbUpdate }
  end

  def pbRefresh
    # Set the background image (per-pocket numbered, same as default)
    @sprites["background"].setBitmap(sprintf("Graphics/UI/Bag/bg_%d", @bag.last_viewed_pocket))
    # Set the bag sprite (per-pocket numbered, female variant if available)
    fbagexists = pbResolveBitmap(sprintf("Graphics/UI/Bag/bag_%d_f", @bag.last_viewed_pocket))
    if $player.female? && fbagexists
      @sprites["bagsprite"].setBitmap(sprintf("Graphics/UI/Bag/bag_%d_f", @bag.last_viewed_pocket))
    else
      @sprites["bagsprite"].setBitmap(sprintf("Graphics/UI/Bag/bag_%d", @bag.last_viewed_pocket))
    end
    # Sync the active search/display filter to the item window
    @sprites["itemlist"].display_filter = @display_filter
    # Draw the pocket icons
    @sprites["pocketicon"].bitmap.clear
    if @choosing && @filterlist
      (1...@bag.pockets.length).each do |i|
        next if @filterlist[i].length > 0
        @sprites["pocketicon"].bitmap.blt(
          6 + ((i - 1) * 22), 6, @pocketbitmap.bitmap, Rect.new((i - 1) * 20, 28, 20, 20)
        )
      end
    end
    @sprites["pocketicon"].bitmap.blt(
      2 + ((@sprites["itemlist"].pocket - 1) * 22), 2, @pocketbitmap.bitmap,
      Rect.new((@sprites["itemlist"].pocket - 1) * 28, 0, 28, 28)
    )
    # Refresh the item window
    @sprites["itemlist"].refresh
    pbRefreshIndexChanged
  end

  def pbRefreshIndexChanged
    itemlist = @sprites["itemlist"]
    overlay  = @sprites["overlay"].bitmap
    overlay.clear
    # Draw the pocket name
    pbDrawTextPositions(
      overlay,
      [[PokemonBag.pocket_names[@bag.last_viewed_pocket - 1], 94, 186, :center, POCKETNAMEBASECOLOR, POCKETNAMESHADOWCOLOR]]
    )
    # Draw slider arrows
    showslider = false
    if itemlist.top_row > 0
      overlay.blt(470, 16, @sliderbitmap.bitmap, Rect.new(0, 0, 36, 38))
      showslider = true
    end
    if itemlist.top_item + itemlist.page_item_max < itemlist.itemCount
      overlay.blt(470, 228, @sliderbitmap.bitmap, Rect.new(0, 38, 36, 38))
      showslider = true
    end
    # Draw slider box
    if showslider
      sliderheight = 174
      boxheight = (sliderheight * itemlist.page_row_max / itemlist.row_max).floor
      boxheight += [(sliderheight - boxheight) / 2, sliderheight / 6].min
      boxheight = [boxheight.floor, 38].max
      y = 54
      y += ((sliderheight - boxheight) * itemlist.top_row / (itemlist.row_max - itemlist.page_row_max)).floor
      overlay.blt(470, y, @sliderbitmap.bitmap, Rect.new(36, 0, 36, 4))
      i = 0
      while i * 16 < boxheight - 4 - 18
        height = [boxheight - 4 - 18 - (i * 16), 16].min
        overlay.blt(470, y + 4 + (i * 16), @sliderbitmap.bitmap, Rect.new(36, 4, 36, height))
        i += 1
      end
      overlay.blt(470, y + boxheight - 18, @sliderbitmap.bitmap, Rect.new(36, 20, 36, 18))
    end
    # Set the selected item's icon and description
    @sprites["itemicon"].item = itemlist.item
    @sprites["itemtext"].text =
      (itemlist.item) ? GameData::Item.get(itemlist.item).description : _INTL("Close bag.")
    # Draw search hint / active search indicator in the top-left corner
    unless @choosing
      if @search_text && !@search_text.empty?
        total   = @search_total_matches || 0
        pockets = @search_pocket_count  || 0
        search_str = _INTL("\"{1}\" - {2} in {3} pocket(s)", @search_text, total, pockets)
        pbDrawTextPositions(
          overlay,
          [[search_str, 6, 4, :left, Color.new(255, 220, 50), Color.new(80, 60, 0)]]
        )
      else
        pbDrawTextPositions(
          overlay,
          [["[D] Search / Sort", 6, 4, :left, POCKETNAMEBASECOLOR, POCKETNAMESHADOWCOLOR]]
        )
      end
    end
  end

  # Public helper so PokemonBagScreen can move the cursor after a reorder.
  def pbSetItemListIndex(new_idx)
    @sprites["itemlist"].index = new_idx
  end

  def pbRefreshFilter
    @filterlist = nil
    return if !@choosing
    return if @filterproc.nil?
    @filterlist = []
    (1...@bag.pockets.length).each do |i|
      @filterlist[i] = []
      @bag.pockets[i].length.times do |j|
        @filterlist[i].push(j) if @filterproc.call(@bag.pockets[i][j][0])
      end
    end
  end

  #-----------------------------------------------------------------------------
  # Search: build a display_filter matching the current search query.
  # Respects @filterlist (choose-mode filter) as a base set.
  #-----------------------------------------------------------------------------
  def pbRefreshSearchFilter
    @display_filter       = nil
    @search_total_matches = 0
    @search_pocket_count  = 0
    return if @search_text.nil? || @search_text.strip.empty?
    query = @search_text.downcase.strip
    @display_filter = []
    (1...@bag.pockets.length).each do |i|
      @display_filter[i] = []
      @bag.pockets[i].each_with_index do |item_slot, j|
        next if @filterlist && !@filterlist[i].include?(j)
        item_name = GameData::Item.get(item_slot[0]).name.downcase
        @display_filter[i].push(j) if item_name.include?(query)
      end
      if @display_filter[i].length > 0
        @search_total_matches += @display_filter[i].length
        @search_pocket_count  += 1
      end
    end
  end

  # Jump the item window to the first pocket that has search results.
  # Returns true if any pocket had results.
  def pbJumpToFirstSearchResult
    return false if @display_filter.nil?
    (1...@bag.pockets.length).each do |i|
      next if @display_filter[i].nil? || @display_filter[i].empty?
      itemwindow = @sprites["itemlist"]
      if itemwindow.pocket != i
        itemwindow.pocket       = i
        @bag.last_viewed_pocket = i
      end
      itemwindow.index = 0
      return true
    end
    return false
  end

  #-----------------------------------------------------------------------------
  # Sort the items in a single pocket in-place.
  # mode: :name_asc, :name_desc, :qty_asc, :qty_desc, :type_asc
  #-----------------------------------------------------------------------------
  def pbApplySortToPocket(pocket, mode)
    thispocket = @bag.pockets[pocket]
    return if thispocket.length <= 1
    if Settings::BAG_POCKET_AUTO_SORT[pocket - 1]
      pbDisplay(_INTL("This pocket is sorted automatically."))
      return
    end
    case mode
    when :name_asc  then thispocket.sort_by! { |s| GameData::Item.get(s[0]).name }
    when :name_desc then thispocket.sort_by! { |s| GameData::Item.get(s[0]).name }.reverse!
    when :qty_asc   then thispocket.sort_by! { |s| s[1] }
    when :qty_desc  then thispocket.sort_by! { |s| -s[1] }
    when :type_asc
      thispocket.sort_by! { |s|
        d = GameData::Item.get(s[0])
        [pbItemSortCategory(d), d.name]
      }
    end
    # Clear any active search so the sorted order is immediately visible
    @search_text    = nil
    @display_filter = nil
    pbPlayDecisionSE
  end

  # Returns a numeric sort category for an item (used for Type sort).
  def pbItemSortCategory(item_data)
    return 0 if item_data.is_important?
    return 1 if item_data.is_machine?
    return 2 if item_data.is_mail?
    return 3 if item_data.respond_to?(:is_berry?) && item_data.is_berry? rescue nil
    return 4
  end

  #-----------------------------------------------------------------------------
  # Show the Search / Sort menu (bound to Input::SPECIAL in pbChooseItem).
  #-----------------------------------------------------------------------------
  def pbOpenSearchSortMenu
    itemwindow = @sprites["itemlist"]
    pocket     = itemwindow.pocket
    search_label = (@search_text && !@search_text.empty?) ?
      _INTL("Search: \"{1}\"", @search_text) : _INTL("Search Items")
    commands = [
      search_label,
      _INTL("Sort: A to Z"),
      _INTL("Sort: Z to A"),
      _INTL("Sort: Qty High-Low"),
      _INTL("Sort: Qty Low-High"),
      _INTL("Sort: By Type"),
      _INTL("Clear Search"),
      _INTL("Cancel")
    ]
    itemwindow.active = false
    cmd = pbShowCommands(_INTL("Search or sort this pocket?"), commands)
    itemwindow.active = true
    case cmd
    when 0   # Search
      itemwindow.active = false
      entered = pbEnterText(_INTL("Search:"), 0, 16, @search_text || "")
      itemwindow.active = true
      @search_text = (entered && !entered.strip.empty?) ? entered.strip : nil
      pbRefreshSearchFilter
      itemwindow.display_filter = @display_filter
      if @search_text && !@search_text.empty?
        if !pbJumpToFirstSearchResult
          itemwindow.active = false
          pbDisplay(_INTL("No items found for \"{1}\".", @search_text))
          itemwindow.active = true
          @search_text              = nil
          @display_filter           = nil
          itemwindow.display_filter = nil
        end
      end
    when 1 then itemwindow.active = false; pbApplySortToPocket(pocket, :name_asc);  itemwindow.active = true
    when 2 then itemwindow.active = false; pbApplySortToPocket(pocket, :name_desc); itemwindow.active = true
    when 3 then itemwindow.active = false; pbApplySortToPocket(pocket, :qty_desc);  itemwindow.active = true
    when 4 then itemwindow.active = false; pbApplySortToPocket(pocket, :qty_asc);   itemwindow.active = true
    when 5 then itemwindow.active = false; pbApplySortToPocket(pocket, :type_asc);  itemwindow.active = true
    when 6   # Clear search
      @search_text          = nil
      @display_filter       = nil
      @search_total_matches = 0
      @search_pocket_count  = 0
      itemwindow.display_filter = nil
      pbPlayCancelSE
    end
    # Sync filter to window and clamp cursor index
    itemwindow.display_filter = @display_filter
    new_max = [itemwindow.itemCount - 1, 0].max
    itemwindow.index = [itemwindow.index, new_max].min
    pbRefresh
  end

  # Called when the item screen wants an item to be chosen from the screen
  def pbChooseItem
    @sprites["helpwindow"].visible = false
    itemwindow = @sprites["itemlist"]
    thispocket = @bag.pockets[itemwindow.pocket]
    swapinitialpos = -1
    pbActivateWindow(@sprites, "itemlist") do
      loop do
        oldindex = itemwindow.index
        Graphics.update
        Input.update
        pbUpdate
        if itemwindow.sorting && itemwindow.index >= thispocket.length
          itemwindow.index = (oldindex == thispocket.length - 1) ? 0 : thispocket.length - 1
        end
        if itemwindow.index != oldindex
          if itemwindow.sorting
            thispocket.insert(itemwindow.index, thispocket.delete_at(oldindex))
          end
          @bag.set_last_viewed_index(itemwindow.pocket, itemwindow.index)
          pbRefresh
        end
        if itemwindow.sorting
          if Input.trigger?(Input::ACTION) || Input.trigger?(Input::USE)
            itemwindow.sorting = false
            pbPlayDecisionSE
            pbRefresh
          elsif Input.trigger?(Input::BACK)
            thispocket.insert(swapinitialpos, thispocket.delete_at(itemwindow.index))
            itemwindow.index   = swapinitialpos
            itemwindow.sorting = false
            pbPlayCancelSE
            pbRefresh
          end
        else   # Change pockets
          if Input.trigger?(Input::LEFT)
            newpocket = itemwindow.pocket
            loop do
              newpocket = (newpocket == 1) ? PokemonBag.pocket_count : newpocket - 1
              break if !@choosing || newpocket == itemwindow.pocket
              if @filterlist
                break if @filterlist[newpocket].length > 0
              elsif @bag.pockets[newpocket].length > 0
                break
              end
            end
            if itemwindow.pocket != newpocket
              itemwindow.pocket       = newpocket
              @bag.last_viewed_pocket = itemwindow.pocket
              thispocket = @bag.pockets[itemwindow.pocket]
              pbPlayCursorSE
              pbRefresh
            end
          elsif Input.trigger?(Input::RIGHT)
            newpocket = itemwindow.pocket
            loop do
              newpocket = (newpocket == PokemonBag.pocket_count) ? 1 : newpocket + 1
              break if !@choosing || newpocket == itemwindow.pocket
              if @filterlist
                break if @filterlist[newpocket].length > 0
              elsif @bag.pockets[newpocket].length > 0
                break
              end
            end
            if itemwindow.pocket != newpocket
              itemwindow.pocket       = newpocket
              @bag.last_viewed_pocket = itemwindow.pocket
              thispocket = @bag.pockets[itemwindow.pocket]
              pbPlayCursorSE
              pbRefresh
            end
          elsif Input.trigger?(Input::ACTION)   # Start switching the selected item
            if !@choosing && thispocket.length > 1 && itemwindow.index < thispocket.length &&
               !Settings::BAG_POCKET_AUTO_SORT[itemwindow.pocket - 1]
              itemwindow.sorting = true
              swapinitialpos     = itemwindow.index
              pbPlayDecisionSE
              pbRefresh
            end
          elsif Input.trigger?(Input::SPECIAL)   # D: Open Search / Sort menu
            pbOpenSearchSortMenu
            thispocket = @bag.pockets[itemwindow.pocket]
          elsif Input.trigger?(Input::BACK)   # Cancel the item screen
            pbPlayCloseMenuSE
            return nil
          elsif Input.trigger?(Input::USE)   # Choose selected item
            (itemwindow.item) ? pbPlayDecisionSE : pbPlayCloseMenuSE
            return itemwindow.item
          end
        end
      end
    end
  end
end

#===============================================================================
# Bag mechanics
#===============================================================================
class PokemonBagScreen
  def initialize(scene, bag)
    @bag   = bag
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene(@bag)
    item = nil
    loop do
      item = @scene.pbChooseItem
      break if !item
      itm = GameData::Item.get(item)
      cmdRead     = -1
      cmdUse      = -1
      cmdRegister = -1
      cmdGive     = -1
      cmdToss     = -1
      cmdMove     = -1
      cmdDebug    = -1
      commands = []
      # Generate command list
      commands[cmdRead = commands.length] = _INTL("Read") if itm.is_mail?
      if ItemHandlers.hasOutHandler(item) || (itm.is_machine? && $player.party.length > 0)
        if ItemHandlers.hasUseText(item)
          commands[cmdUse = commands.length] = ItemHandlers.getUseText(item)
        else
          commands[cmdUse = commands.length] = _INTL("Use")
        end
      end
      commands[cmdGive = commands.length]  = _INTL("Give") if $player.pokemon_party.length > 0 && itm.can_hold?
      commands[cmdToss = commands.length]  = _INTL("Toss") if !itm.is_important? || $DEBUG
      # Move: reorder this item within its pocket (blocked on auto-sorted pockets)
      cur_pocket_idx = @bag.last_viewed_pocket
      if !Settings::BAG_POCKET_AUTO_SORT[cur_pocket_idx - 1] &&
         @bag.pockets[cur_pocket_idx].length > 1
        commands[cmdMove = commands.length] = _INTL("Move")
      end
      if @bag.registered?(item)
        commands[cmdRegister = commands.length] = _INTL("Deselect")
      elsif pbCanRegisterItem?(item)
        commands[cmdRegister = commands.length] = _INTL("Register")
      end
      commands[cmdDebug = commands.length] = _INTL("Debug") if $DEBUG
      commands[commands.length]            = _INTL("Cancel")
      # Show commands generated above
      itemname = itm.name
      command  = @scene.pbShowCommands(_INTL("{1} is selected.", itemname), commands)
      if cmdRead >= 0 && command == cmdRead   # Read mail
        pbFadeOutIn do
          pbDisplayMail(Mail.new(item, "", ""))
        end
      elsif cmdUse >= 0 && command == cmdUse   # Use item
        ret = pbUseItem(@bag, item, @scene)
        # ret: 0=Item wasn't used; 1=Item used; 2=Close Bag to use in field
        break if ret == 2
        @scene.pbRefresh
        next
      elsif cmdGive >= 0 && command == cmdGive   # Give item to Pokémon
        if $player.pokemon_count == 0
          @scene.pbDisplay(_INTL("There is no Pokémon."))
        elsif itm.is_important?
          @scene.pbDisplay(_INTL("The {1} can't be held.", itm.portion_name))
        else
          pbFadeOutIn do
            sscene  = PokemonParty_Scene.new
            sscreen = PokemonPartyScreen.new(sscene, $player.party)
            sscreen.pbPokemonGiveScreen(item)
            @scene.pbRefresh
          end
        end
      elsif cmdToss >= 0 && command == cmdToss   # Toss item
        qty = @bag.quantity(item)
        if qty > 1
          helptext = _INTL("Toss out how many {1}?", itm.portion_name_plural)
          qty = @scene.pbChooseNumber(helptext, qty)
        end
        if qty > 0
          itemname = (qty > 1) ? itm.portion_name_plural : itm.portion_name
          if pbConfirm(_INTL("Is it OK to throw away {1} {2}?", qty, itemname))
            pbDisplay(_INTL("Threw away {1} {2}.", qty, itemname))
            qty.times { @bag.remove(item) }
            @scene.pbRefresh
          end
        end
      elsif cmdMove >= 0 && command == cmdMove   # Move item within pocket
        pbMoveItemToPocket(item, itm)
        @scene.pbRefresh
      elsif cmdRegister >= 0 && command == cmdRegister   # Register item
        if @bag.registered?(item)
          @bag.unregister(item)
        else
          @bag.register(item)
        end
        @scene.pbRefresh
      elsif cmdDebug >= 0 && command == cmdDebug   # Debug
        command = 0
        loop do
          command = @scene.pbShowCommands(_INTL("Do what with {1}?", itemname),
                                          [_INTL("Change quantity"),
                                           _INTL("Make Mystery Gift"),
                                           _INTL("Cancel")], command)
          case command
          ### Cancel ###
          when -1, 2
            break
          ### Change quantity ###
          when 0
            qty = @bag.quantity(item)
            itemplural = itm.name_plural
            params = ChooseNumberParams.new
            params.setRange(0, Settings::BAG_MAX_PER_SLOT)
            params.setDefaultValue(qty)
            newqty = pbMessageChooseNumber(
              _INTL("Choose new quantity of {1} (max. {2}).", itemplural, Settings::BAG_MAX_PER_SLOT), params
            ) { @scene.pbUpdate }
            if newqty > qty
              @bag.add(item, newqty - qty)
            elsif newqty < qty
              @bag.remove(item, qty - newqty)
            end
            @scene.pbRefresh
            break if newqty == 0
          ### Make Mystery Gift ###
          when 1
            pbCreateMysteryGift(1, item)
          end
        end
      end
    end
    ($game_temp.fly_destination) ? @scene.dispose : @scene.pbEndScene
    return item
  end

  def pbDisplay(text)
    @scene.pbDisplay(text)
  end

  def pbConfirm(text)
    return @scene.pbConfirm(text)
  end

  #-----------------------------------------------------------------------------
  # Reorder an item within its current pocket.
  #-----------------------------------------------------------------------------
  def pbMoveItemToPocket(item, itm)
    pocket_idx = @bag.last_viewed_pocket
    pocket     = @bag.pockets[pocket_idx]
    cur_idx    = pocket.index { |s| s[0] == item }
    return if cur_idx.nil?

    at_top    = cur_idx == 0
    at_bottom = cur_idx == pocket.length - 1

    options = []
    options << _INTL("Move Up")        unless at_top
    options << _INTL("Move Down")      unless at_bottom
    options << _INTL("Move to Top")    unless at_top
    options << _INTL("Move to Bottom") unless at_bottom
    options << _INTL("Cancel")

    cmd = @scene.pbShowCommands(_INTL("Move {1} where?", itm.name), options)
    return if cmd < 0 || options[cmd] == _INTL("Cancel")

    chosen = options[cmd]
    case chosen
    when _INTL("Move Up")        then new_idx = cur_idx - 1
    when _INTL("Move Down")      then new_idx = cur_idx + 1
    when _INTL("Move to Top")    then new_idx = 0
    when _INTL("Move to Bottom") then new_idx = pocket.length - 1
    else return
    end

    pocket.insert(new_idx, pocket.delete_at(cur_idx))
    @scene.pbSetItemListIndex(new_idx)
    @bag.set_last_viewed_index(pocket_idx, new_idx)
  end

  # UI logic for the item screen for choosing an item.
  def pbChooseItemScreen(proc = nil)
    oldlastpocket = @bag.last_viewed_pocket
    oldchoices    = @bag.last_pocket_selections.clone
    @bag.reset_last_selections if proc
    @scene.pbStartScene(@bag, true, proc)
    item = @scene.pbChooseItem
    @scene.pbEndScene
    @bag.last_viewed_pocket     = oldlastpocket
    @bag.last_pocket_selections = oldchoices
    return item
  end

  # UI logic for withdrawing an item in the item storage screen.
  def pbWithdrawItemScreen
    if !$PokemonGlobal.pcItemStorage
      $PokemonGlobal.pcItemStorage = PCItemStorage.new
    end
    storage = $PokemonGlobal.pcItemStorage
    @scene.pbStartScene(storage)
    loop do
      item = @scene.pbChooseItem
      break if !item
      itm = GameData::Item.get(item)
      qty = storage.quantity(item)
      if qty > 1 && !itm.is_important?
        qty = @scene.pbChooseNumber(_INTL("How many do you want to withdraw?"), qty)
      end
      next if qty <= 0
      if @bag.can_add?(item, qty)
        if !storage.remove(item, qty)
          raise "Can't delete items from storage"
        end
        if !@bag.add(item, qty)
          raise "Can't withdraw items from storage"
        end
        @scene.pbRefresh
        dispqty  = (itm.is_important?) ? 1 : qty
        itemname = (dispqty > 1) ? itm.portion_name_plural : itm.portion_name
        pbDisplay(_INTL("Withdrew {1} {2}.", dispqty, itemname))
      else
        pbDisplay(_INTL("There's no more room in the Bag."))
      end
    end
    @scene.pbEndScene
  end

  # UI logic for depositing an item in the item storage screen.
  def pbDepositItemScreen
    @scene.pbStartScene(@bag)
    if !$PokemonGlobal.pcItemStorage
      $PokemonGlobal.pcItemStorage = PCItemStorage.new
    end
    storage = $PokemonGlobal.pcItemStorage
    loop do
      item = @scene.pbChooseItem
      break if !item
      itm = GameData::Item.get(item)
      qty = @bag.quantity(item)
      if qty > 1 && !itm.is_important?
        qty = @scene.pbChooseNumber(_INTL("How many do you want to deposit?"), qty)
      end
      if qty > 0
        if storage.can_add?(item, qty)
          if !@bag.remove(item, qty)
            raise "Can't delete items from Bag"
          end
          if !storage.add(item, qty)
            raise "Can't deposit items to storage"
          end
          @scene.pbRefresh
          dispqty  = (itm.is_important?) ? 1 : qty
          itemname = (dispqty > 1) ? itm.portion_name_plural : itm.portion_name
          pbDisplay(_INTL("Deposited {1} {2}.", dispqty, itemname))
        else
          pbDisplay(_INTL("There's no room to store items."))
        end
      end
    end
    @scene.pbEndScene
  end

  # UI logic for tossing an item in the item storage screen.
  def pbTossItemScreen
    if !$PokemonGlobal.pcItemStorage
      $PokemonGlobal.pcItemStorage = PCItemStorage.new
    end
    storage = $PokemonGlobal.pcItemStorage
    @scene.pbStartScene(storage)
    loop do
      item = @scene.pbChooseItem
      break if !item
      itm = GameData::Item.get(item)
      if itm.is_important?
        @scene.pbDisplay(_INTL("That's too important to toss out!"))
        next
      end
      qty            = storage.quantity(item)
      itemname       = itm.portion_name
      itemnameplural = itm.portion_name_plural
      if qty > 1
        qty = @scene.pbChooseNumber(_INTL("Toss out how many {1}?", itemnameplural), qty)
      end
      next if qty <= 0
      itemname = itemnameplural if qty > 1
      next if !pbConfirm(_INTL("Is it OK to throw away {1} {2}?", qty, itemname))
      if !storage.remove(item, qty)
        raise "Can't delete items from storage"
      end
      @scene.pbRefresh
      pbDisplay(_INTL("Threw away {1} {2}.", qty, itemname))
    end
    @scene.pbEndScene
  end
end
