require 'spec_helper'

require 'CKey/CKey'

require 'helpers/ckey_helper'

describe CKey do

  it "invokes main api when using test methods" do
    CKey.stub(:grab_keyboard).with(subject)
    CKey.should_receive(:grab_keyboard).with(subject)
    CKey.test(subject).puts('a')
  end

  describe "delegates events" do

    before do
      @dispatcher = EventDispatchers::SimpleDispatcher.new
    end

    it "delegates single-key events" do
      @dispatcher.should_receive(:key_press).with('a').once
      @dispatcher.should_receive(:key_release).with('a').once
      CKey.test(@dispatcher).puts('a')
    end

    it "delegates all events" do
      @dispatcher.should_receive(:key_press).with('a').exactly(3).times
      @dispatcher.should_receive(:key_release).with('a').exactly(3).times
      @dispatcher.should_receive(:key_press).with('b').once
      @dispatcher.should_receive(:key_release).with('b').once
      CKey.test(@dispatcher).puts('a')
      CKey.test(@dispatcher).puts('a')
      CKey.test(@dispatcher).puts('b')
      CKey.test(@dispatcher).puts('a')
    end

    it "informs about user's idleness" do
      @dispatcher.should_receive(:wait).with().twice
      CKey.test(@dispatcher).wait(2)
    end

  end

end
