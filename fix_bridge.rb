content = File.read("Plugins/Roguelike_Extraction/012_DBK_Factory_Bridge.rb")
unless content.include?("setBattleRule(\"databoxStyle\", [:Long, \"{1}\"])")
  content.gsub!("setBattleRule(\"cannotRun\")", "setBattleRule(\"cannotRun\")\n  setBattleRule(\"databoxStyle\", [:Long, \"{1}\"])")
  File.write("Plugins/Roguelike_Extraction/012_DBK_Factory_Bridge.rb", content)
end
