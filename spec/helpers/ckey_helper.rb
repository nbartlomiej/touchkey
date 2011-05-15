# stub for the EventDispatcher class
class EventDispatcher
end

# enhancements to CKey for manual event sending
module CKey

  # Xlib's values of event types
  KEY_PRESS = 2
  KEY_RELEASE = 3

  def self.test(event_dispatcher)
    @@target_dispatcher = event_dispatcher
    self
  end

  def self.puts(key)
    self.push_test(key, KEY_PRESS)
    self.grab_keyboard(@@target_dispatcher)
    self.push_test(key, KEY_RELEASE)
    self.grab_keyboard(@@target_dispatcher)
  end

end
