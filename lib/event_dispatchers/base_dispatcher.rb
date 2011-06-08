module EventDispatchers
  class BaseDispatcher
    def key_press(key)
      raise NotImplementedError
    end

    def key_release(key)
      raise NotImplementedError
    end

    def wait
      raise NotImplementedError
    end

    def signal type, code=nil
      send(type, code)
    end
  end
end
