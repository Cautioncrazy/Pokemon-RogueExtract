module GameData; class Trainer; DATA = {}; end; end
GameData::Trainer::DATA = Marshal.load(File.binread("Data/trainers.dat"))
keys = GameData::Trainer::DATA.keys.select { |k| k[1].include?("M") && k[1].include?("F") }
puts "Found procedural keys: #{keys.length}"
keys.each { |k| puts k.inspect }
