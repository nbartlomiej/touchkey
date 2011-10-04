# stub for the EventDispatcher class
class EventDispatcher
end

# enhancements to CKey for manual event sending
module Touchkey::Key


  def self.test(event_dispatcher)
    @@target_dispatcher = event_dispatcher
    self
  end

  def self.puts(key)
    self.push_test(key, Touchkey::Portable.key_press)
    self.grab_keyboard(@@target_dispatcher)
    self.push_test(key, Touchkey::Portable.key_release)
    self.grab_keyboard(@@target_dispatcher)
  end

  def self.idle(ticks)
    self.push_test_idle(ticks)
    self.grab_keyboard(@@target_dispatcher)
  end

end
