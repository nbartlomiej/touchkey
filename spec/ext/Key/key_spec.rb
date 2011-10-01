require 'spec_helper'

require 'touchkey/event_dispatchers/simple_dispatcher'
require 'touchkey/portable'
Touchkey::Portable::require_native 'touchkey/Key/Key'

require 'helpers/ckey_helper'

describe CKey do

  it "invokes main api when using test methods" do
    CKey.stub(:grab_keyboard).with(subject)
    CKey.should_receive(:grab_keyboard).with(subject)
    CKey.test(subject).puts('a')
  end

  describe "delegates events" do

    before do
      @dispatcher = Touchkey::EventDispatchers::SimpleDispatcher.new
    end

    it "is a test test" do
      Touchkey::Key.grab_keyboard(nil)
    end

    it "delegates single-key events" do
      @dispatcher.should_receive(:signal).with('key_press', 'a').once
      @dispatcher.should_receive(:signal).with('key_release', 'a').once
      CKey.test(@dispatcher).puts('a')
    end

    it "delegates all events" do
      @dispatcher.should_receive(:signal).with('key_press', 'a').exactly(3).times
      @dispatcher.should_receive(:signal).with('key_release', 'a').exactly(3).times
      @dispatcher.should_receive(:signal).with('key_press', 'b').once
      @dispatcher.should_receive(:signal).with('key_release', 'b').once
      CKey.test(@dispatcher).puts('a')
      CKey.test(@dispatcher).puts('a')
      CKey.test(@dispatcher).puts('b')
      CKey.test(@dispatcher).puts('a')
    end

    it "informs about user's idleness" do
      @dispatcher.should_receive(:signal).with('idle').twice
      CKey.test(@dispatcher).idle(2)
    end

  end

end
