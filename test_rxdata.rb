anims = load_data("Data/PkmnAnimations.rxdata")
puts "Class of anims: #{anims.class}"
puts "First element: #{anims[0].class}"
puts "Second element: #{anims[1].class}"
puts "Has each? #{anims.respond_to?(:each)}"
