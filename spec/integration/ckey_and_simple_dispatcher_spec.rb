require 'spec_helper'

describe "Key and SimpleDispatcher" do
  it "alters mouse position" do
    Touchkey::Mouse.should_receive(:set_mouse_abs)
    Touchkey::Key.test(Touchkey::EventDispatchers::SimpleDispatcher.new).puts('a')
  end
end
