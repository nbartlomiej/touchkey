$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"

module EventDispatchers

  require 'event_dispatchers/base_dispatcher'

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
  end
end
