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
    if !base_anims || !base_anims.is_a?(Array)
      pbMessage(_INTL("Base file format is invalid!"))
      return
    end

    total_added = 0
    total_overwritten = 0

    # Iterate backwards so highest priority overwrites lower priorities
    reversed_packs = ordered_packs.reverse

    reversed_packs.each do |pack|
      custom_anims = load_data(pack[:path])
      next if !custom_anims || !custom_anims.is_a?(Array)

      custom_anims.each do |custom_anim|
        next if !custom_anim || !custom_anim.name || custom_anim.name.empty?

        # Check if animation with same name exists in base_anims
        existing_index = base_anims.find_index { |a| a && a.name == custom_anim.name }

        if existing_index
          # Deep Merge instead of blindly overwriting the whole object
          base_anim = base_anims[existing_index]

          # Only inherit the graphic string if the custom one actually provides one
          if custom_anim.graphic != ""
            base_anim.graphic = custom_anim.graphic
            base_anim.hue = custom_anim.hue
          end

          # Overwrite frames and timing entirely as that contains the actual animation sequence
          base_anim.array = custom_anim.array
          base_anim.timing = custom_anim.timing

          # Maintain other positional properties
          base_anim.position = custom_anim.position

          total_overwritten += 1
        else
          base_anims.push(custom_anim)
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
