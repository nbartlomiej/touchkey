require 'spec_helper'

require 'CKey/CKey'
require 'CKey/parallelizer'
include CKey

class EventDispatcher
end

describe "CKey" do

  describe "delegate event to the EventDispatcher" do
    it "should invoke EventDispatcher's key_press" do
      ed = EventDispatcher.new
      set_event_dispatcher(ed)
      grab_keyboard
      ed.stub(:key_press).with('A'){ true }
      ed.should_receive(:key_press).with('A')
      simulate_keypress('A')
    end
  end

end
