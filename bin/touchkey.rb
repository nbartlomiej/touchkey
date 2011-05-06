# LOAD_PATH is a ruby construct, works in a similar
# fashion as $PATH
$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"

require 'CMouse/CMouse'
include CMouse

puts set_mouse_abs(100, 200)
puts set_mouse_rel(100, 200)
