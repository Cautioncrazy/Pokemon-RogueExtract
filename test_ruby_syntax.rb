require 'parser/current'

begin
  Parser::CurrentRuby.parse_file('Data/Scripts/011_Battle/001_Battle/011_Battle_EndOfRoundPhase.rb')
  puts "Syntax OK"
rescue => e
  puts "Syntax Error: #{e.message}"
end
