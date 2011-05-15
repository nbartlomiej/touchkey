require 'spec_helper'

require 'event_dispatcher'

describe "EventDispatcher" do
  describe "captures letters and sets mouse accordingly" do
    it "puts mouse in the top left corner" do
      event_dispatcher = EventDispatcher.new
      CMouse.stub(:set_mouse_abs).with(0,0)
      CMouse.should_receive(:set_mouse_abs).with(0,0)
      event_dispatcher.key_press('1')
    end
  end
end
  
