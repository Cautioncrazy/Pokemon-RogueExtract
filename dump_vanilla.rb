module RPG; class Animation; end; end
class Color; def initialize(*a); end; def self._load(s); new; end; end
class Tone; def initialize(*a); end; def self._load(s); new; end; end
require "./Data/Scripts/011_Battle/007_Other battle code/007_BattleAnimationPlayer.rb"

def load_data(file)
  File.open(file, "rb") { |f| Marshal.load(f) }
end

base_anims = load_data("Data/PkmnAnimations.rxdata")
anim1 = base_anims.get_from_name("Common:Rain")
puts "Common:Rain"
puts "  Length: #{anim1&.length}"
puts "  Graphic: '#{anim1&.graphic}'"
puts "  Timings: #{anim1&.timing&.length}"

anim2 = base_anims.get_from_name("Common:SuperShiny")
puts "Common:SuperShiny"
puts "  Length: #{anim2&.length}"
puts "  Graphic: '#{anim2&.graphic}'"
puts "  Timings: #{anim2&.timing&.length}"
