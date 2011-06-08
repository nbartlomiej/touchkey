require 'spec_helper'

require 'event_dispatchers/simple_dispatcher'

require 'CKey/CKey'
require 'helpers/ckey_helper'

describe "CKey and SimpleDispatcher" do
  it "alters mouse position" do
    CMouse.should_receive(:set_mouse_abs)
    CKey.test(EventDispatchers::SimpleDispatcher.new).puts('a')
  end
end
