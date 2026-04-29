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
    # Strip any procedural floor numbers (e.g., "cave_FIRE_0" -> "cave_FIRE")
    clean_theme = theme_str.to_s.sub(/_\d+$/, '').to_sym
    return DATA[clean_theme] || DATA[:cave] # Fallback to standard cave
  end
end
