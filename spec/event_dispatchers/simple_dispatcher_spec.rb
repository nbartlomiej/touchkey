require 'touchkey/event_dispatchers/simple_dispatcher'
describe Touchkey::EventDispatchers::SimpleDispatcher do
  describe "captures letters and sets mouse accordingly" do
    it "puts mouse in the top left corner" do
      simple_dispatcher = Touchkey::EventDispatchers::SimpleDispatcher.new
      Touchkey::Mouse.stub(:set_mouse_abs).with(0,0)
      Touchkey::Mouse.should_receive(:set_mouse_abs).with(0,0)
      simple_dispatcher.key_press('1')
    end
  end
end
