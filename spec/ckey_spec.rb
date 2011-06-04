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
      @e = EventDispatcher.new
    end

    it "delegates single-key events" do
      @e.should_receive(:key_press).with('a').once
      @e.should_receive(:key_release).with('a').once
      CKey.test(@e).puts('a')
    end

    it "delegates all events" do
      @e.should_receive(:key_press).with('a').exactly(3).times
      @e.should_receive(:key_release).with('a').exactly(3).times
      @e.should_receive(:key_press).with('b').once
      @e.should_receive(:key_release).with('b').once
      CKey.test(@e).puts('a')
      CKey.test(@e).puts('a')
      CKey.test(@e).puts('b')
      CKey.test(@e).puts('a')
    end

    it "informs about user's idleness" do
      @e.should_receive(:wait).with().twice
      CKey.test(@e).wait(2)
    end

  end

end
