require 'pp'

begin
  mapinfos = File.open("Data/MapInfos.rxdata", "rb") { |f| Marshal.load(f) }
  last_map_id = mapinfos.keys.max
  map = File.open("Data/Map%03d.rxdata" % last_map_id, "rb") { |f| Marshal.load(f) }
  puts "Map ID: #{last_map_id}"
  puts "Total Events: #{map.events.size}"

  event_counts = Hash.new(0)
  map.events.each_value do |ev|
    event_counts[ev.name.downcase] += 1
  end
  puts "Event Types Count:"
  pp event_counts
rescue => e
  puts "Error: #{e.message}"
end
