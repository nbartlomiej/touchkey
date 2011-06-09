module EventDispatchers
  class BaseDispatcher
    def key_press(key)
      raise NotImplementedError
    end

    def key_release(key)
      raise NotImplementedError
    end

    def idle
      raise NotImplementedError
    end

    # received from CKey when an event occurrs;
    # sample calls:
    #   signal('key_press', 'a')
    #   signal('key_release', 'b')
    #   signal('idle')
    def signal type, *args
      send(type, *args)
    end

  end
end
