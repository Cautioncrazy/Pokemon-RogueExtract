module RPG; class Animation; end; end
class Color; def initialize(*a); end; def self._load(s); new; end; end
class Tone; def initialize(*a); end; def self._load(s); new; end; end
require "./Data/Scripts/011_Battle/007_Other battle code/007_BattleAnimationPlayer.rb"

def load_data(file)
  File.open(file, "rb") { |f| Marshal.load(f) }
end

base_anims = load_data("Data/PkmnAnimations.rxdata")
anim1 = base_anims.get_from_name("Common:Rain")

def is_anim_empty?(anim)
  return true if !anim
  has_cels = anim.any? { |frame| frame && frame.length > 0 }
  has_timings = anim.timing.length > 0
  return !has_cels && !has_timings
end

puts "Common:Rain is empty? #{is_anim_empty?(anim1)}"
anim2 = base_anims.get_from_name("COMMON")
puts "COMMON is empty? #{is_anim_empty?(anim2)}"
