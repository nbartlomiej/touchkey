$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"

require 'CMouse/CMouse'

class EventDispatcher
  def key_press(key)
    @keys.each_with_index do |line, local_y|
      line.split(//).each_with_index do |letter, local_x|
        if letter == key
          x_ratio, y_ratio = @width / (line.length-1), @height / (@keys.length-1)
          x = local_x * x_ratio
          y = local_y * y_ratio
          CMouse.set_mouse_abs(x, y)
        end
      end
    end
  end

  def key_release(key)
    puts "key_release received: #{key}"
  end

  def initialize
    @keys = ['1234567890', 'qwertyuiop', 'asdfghjkl;', 'zxcvbnm,./']
    @width, @height = `xrandr`.scan(/current (\d+) x (\d+)/).flatten.map do |str|
      str.to_i
    end
  end

end

