# Animation Merger Tool
# Scans Plugins/ for PkmnAnimations.rxdata files
# Allows priority ordering and merges into Data/PkmnAnimations.rxdata

module AnimationMerger
  def self.scan_for_animations
    anim_files = []
    Dir.glob("Plugins/**/PkmnAnimations.rxdata").each do |path|
      anim_files.push(path)
    end
    return anim_files
  end

  def self.run
    anim_files = scan_for_animations
    if anim_files.empty?
      pbMessage(_INTL("No custom PkmnAnimations.rxdata found in Plugins/."))
      return
    end

    packs = []
    anim_files.each do |f|
      folder = File.basename(File.dirname(f))
      packs.push({:path => f, :name => folder})
    end

    ordered_packs = []
    remaining_packs = packs.clone

    while remaining_packs.length > 0
      commands = remaining_packs.map { |p| p[:name] }
      msg = _INTL("Select the pack for Priority Rank {1} (Highest).", ordered_packs.length + 1)
      if ordered_packs.length > 0
        msg = _INTL("Select the pack for Priority Rank {1}.", ordered_packs.length + 1)
      end

      cmd = pbMessage(msg, commands, -1)
      if cmd == -1
        if pbMessage(_INTL("Cancel animation merging?"), [_INTL("Yes"), _INTL("No")], 2) == 0
          return
        else
          next
        end
      end

      selected = remaining_packs.delete_at(cmd)
      ordered_packs.push(selected)
    end

    summary = ""
    ordered_packs.each_with_index do |p, i|
      summary += "#{i+1}: #{p[:name]}\n"
    end

    if pbMessage(_INTL("Merge with this priority?\n{1}", summary), [_INTL("Yes"), _INTL("No")], 2) != 0
      return
    end

    # Merge Logic
    base_file = "Data/PkmnAnimations.rxdata"
    if !File.exist?(base_file)
      pbMessage(_INTL("Base {1} not found!", base_file))
      return
    end

    base_anims = load_data(base_file)
    # Essentials v21 PBAnimations inherits from Array and stores actual animations in @array
    if !base_anims || !base_anims.respond_to?(:array) || !base_anims.array.is_a?(Array)
      pbMessage(_INTL("Base file format is invalid!"))
      return
    end

    base_array = base_anims.array
    total_added = 0
    total_overwritten = 0

    # Iterate backwards so highest priority overwrites lower priorities
    reversed_packs = ordered_packs.reverse

    reversed_packs.each do |pack|
      custom_anims = load_data(pack[:path])
      next if !custom_anims || !custom_anims.respond_to?(:array) || !custom_anims.array.is_a?(Array)

      custom_array = custom_anims.array
      custom_array.each do |custom_anim|
        next if !custom_anim || !custom_anim.name || custom_anim.name.empty?

        # Skip blank/empty animations that plugin authors accidentally saved over vanilla slots
        has_cels = custom_anim.any? { |frame| frame && frame.length > 0 }
        has_timings = custom_anim.timing && custom_anim.timing.length > 0
        next if !has_cels && !has_timings

        # Check if animation with same name exists in base_array
        existing_index = base_array.find_index { |a| a && a.name == custom_anim.name }

        if existing_index
          base_anim = base_array[existing_index]

          # If the custom animation doesn't provide a graphic, inherit from the base animation
          if !custom_anim.graphic || custom_anim.graphic == ""
            custom_anim.graphic = base_anim.graphic
            custom_anim.hue = base_anim.hue
          end

          # Ensure the ID remains consistent with the base array
          custom_anim.id = base_anim.id

          # Overwrite the old object entirely in the base_array
          base_array[existing_index] = custom_anim

          total_overwritten += 1
        else
          # Add to base array and update its ID sequentially
          custom_anim.id = base_array.length
          base_array.push(custom_anim)
          total_added += 1
        end
      end
    end

    # Save output
    save_data(base_anims, base_file)
    pbMessage(_INTL("Merge complete!\nAnimations Added: {1}\nAnimations Overwritten: {2}", total_added, total_overwritten))
  end
end

MenuHandlers.add(:debug_menu, :animation_merger, {
  "name"        => _INTL("Animation Merger"),
  "parent"      => :editors_menu,
  "description" => _INTL("Merge custom PkmnAnimations.rxdata from plugins into base file."),
  "effect"      => proc {
    AnimationMerger.run
  }
})
