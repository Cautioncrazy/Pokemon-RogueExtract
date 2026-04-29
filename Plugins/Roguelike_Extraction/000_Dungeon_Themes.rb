#===============================================================================
# Dungeon Themes Registry
#===============================================================================
# A centralized configuration module replacing complex string parsing.
# Maps clean theme names to their physical terrain behavior and type pool.
#===============================================================================

module DungeonThemes
  DATA = {
    :cave       => { :terrain => :Cave, :type => nil },
    :cave_FIRE  => { :terrain => :Cave, :type => :FIRE },
    :forest     => { :terrain => :Land, :type => nil },
    :forest_ICE => { :terrain => :Land, :type => :ICE }
  }

  def self.get(theme_str)
    return nil if !theme_str || theme_str == :none
    str = theme_str.to_s

    # Sort keys by length descending to ensure we check specific themes (cave_FIRE)
    # before generic themes (cave)
    sorted_keys = DATA.keys.sort_by { |k| -k.to_s.length }

    # Find the first key that is included anywhere in the map's theme string
    match = sorted_keys.find { |k| str.include?(k.to_s) }

    return DATA[match] if match
    return DATA[:cave] # Ultimate fallback
  end
end
