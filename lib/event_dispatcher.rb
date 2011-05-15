$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"

require 'CKey/CKey'
require 'CMouse/CMouse'

class EventDispatcher
  def key_press(key)
    puts "key_press received: #{key}"
  end

  def key_release(key)
    puts "key_release received: #{key}"
  end

  def initialize
    keys = ['qwertyuiop', 'asdfghjkl;', 'zxcvbnm,./']
    width = 1440
    height = 900
  end

end

