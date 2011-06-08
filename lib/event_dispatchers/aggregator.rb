module EventDispatchers
  class Aggregator < BaseDispatcher
    def key_press(key)
      raise NotImplementedError
    end

    def key_release(key)
      raise NotImplementedError
    end

    def wait
      raise NotImplementedError
    end
  end
end
