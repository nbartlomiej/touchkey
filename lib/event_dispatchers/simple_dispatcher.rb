$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"

module EventDispatchers

  require 'CMouse/CMouse'

  require 'event_dispatchers/base_dispatcher'

  class SimpleDispatcher < BaseDispatcher
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
    end

    def wait
      sleep(0.01)
    end

    def initialize
      @keys = ['1234567890', 'qwertyuiop', 'asdfghjkl;', 'zxcvbnm,./']
      @width, @height = `xrandr`.scan(/current (\d+) x (\d+)/).flatten.map do |str|
        str.to_i
      end
    end

  end

end
