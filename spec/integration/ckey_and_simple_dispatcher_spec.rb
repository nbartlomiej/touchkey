require 'spec_helper'

describe "CKey and SimpleDispatcher" do
  it "alters mouse position" do
    CMouse.should_receive(:set_mouse_abs)
    CKey.test(EventDispatchers::SimpleDispatcher.new).puts('a')
  end
end
