module Touchkey
  module EventDispatchers

    # require 'event_dispatchers/base_dispatcher'

    class Aggregator < BaseDispatcher
      def key_press(key)
        raise NotImplementedError
      end

      def key_release(key)
        raise NotImplementedError
      end

      def idle
        raise NotImplementedError
      end

      def initialize
        @event_cache = Event.new('key_release', 0)
      end

      # aggregates repeating key_release-key_press sequences
      def signal(code, *args)
        if @event_cache.code=='key_release' && code=='key_press' && @event_cache.args == args
          send('idle')
          @key_release_waiting = true
        elsif code=='key_release' && @event_cache.code=='key_press' && @event_cache.args == args
          send('idle')
        else
          if code=='idle' && @key_release_waiting
            send('key_release', *@event_cache.args)
          else
            send(code, *args)
          end
          @key_release_waiting = false
        end

        if code == 'key_press' || code == 'key_release'
          @event_cache = Event.new(code, args)
        end
      end

      private

      class Event
        attr_accessor :code
        attr_accessor :args
        def initialize code, args
          @code, @args = code, args
        end
      end

    end
  end
end
