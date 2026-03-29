module RPG; class Animation; end; end
class Color; def initialize(*a); end; def self._load(s); new; end; end
class Tone; def initialize(*a); end; def self._load(s); new; end; end
require "./Data/Scripts/011_Battle/007_Other battle code/007_BattleAnimationPlayer.rb"

def load_data(file)
  File.open(file, "rb") { |f| Marshal.load(f) }
end

base_anims = load_data("Data/PkmnAnimations.rxdata")
anim = base_anims.get_from_name("Flamethrower")
puts "Flamethrower graphic: '#{anim&.graphic}'"
