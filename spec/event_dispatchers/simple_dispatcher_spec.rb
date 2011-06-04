require 'spec_helper'

require 'event_dispatchers/simple_dispatcher'

describe EventDispatchers::SimpleDispatcher do
  describe "captures letters and sets mouse accordingly" do
    it "puts mouse in the top left corner" do
      simple_dispatcher = EventDispatchers::SimpleDispatcher.new
      CMouse.stub(:set_mouse_abs).with(0,0)
      CMouse.should_receive(:set_mouse_abs).with(0,0)
      simple_dispatcher.key_press('1')
    end
  end
end

