module Touchkey
  module EventDispatchers

    require 'CMouse/CMouse'
    require 'event_dispatchers/aggregator'
    require 'event_dispatchers/base_dispatcher'

    class Magnetic < BaseDispatcher
      def key_press(key)
        @keys.each_with_index do |line, local_y|
          line.split(//).each_with_index do |letter, local_x|
            if letter == key
              x_ratio, y_ratio = @width / (line.length-1), @height / (@keys.length-1)
              @target_x = local_x * x_ratio
              @target_y = local_y * y_ratio
            end
          end
        end
      end

      def key_release(key)
        if key == 'space'
          CMouse.left_click
        else
          @target_x, @target_y = CMouse.get_mouse_x, CMouse.get_mouse_y
        end
      end

      def idle
        x = (@target_x - CMouse.get_mouse_x) / 17
        y = (@target_y - CMouse.get_mouse_y) / 17
        CMouse.set_mouse_abs(CMouse.get_mouse_x+x, CMouse.get_mouse_y+y)
        sleep(0.01)
      end

      def initialize
        super
        @keys = ['1234567890', 'qwertyuiop', 'asdfghjkl;', 'zxcvbnm,./']
        @width, @height = `xrandr`.scan(/current (\d+) x (\d+)/).flatten.map do |str|
          str.to_i
        end
        @target_x, @target_y = 0, 0
      end

    end
  end
end
