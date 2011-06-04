require 'spec_helper'

require 'CKey/CKey'

require 'helpers/ckey_helper'

describe CKey do

  describe "delegate event to the EventDispatcher" do

    # The general test is ready (below) but I have been yet 
    # unable to # make it pass. It requires multiple actions 
    # at once, # i.e.: grabbing the keyboard and simulating 
    # events.
    # Ruby stops managing threads whenever a C extension is
    # being executed. Forking the block in question led me
    # to memory issues, the same happened when I created a
    # thread with C's pthread library. TODO: resolve!
    #
    # it "delegates key_press events to the EventDispatcher" do
    #   event_dispatcher = EventDispatcher.new
    #   CKey.grab_keyboard(event_dispatcher)
    #   event_dispatcher.stub(:key_press).with('a'){ true }
    #   event_dispatcher.should_receive(:key_press).with('a')
    #   CKey.simulate_keypress_supermode('a')
    # end

    before do
      @event_dispatcher = EventDispatcher.new
      @event_dispatcher.stub(:key_press).with('a')
      @event_dispatcher.stub(:key_release).with('a')
      @event_dispatcher.stub(:key_press).with('b')
      @event_dispatcher.stub(:key_release).with('b')
      @event_dispatcher.stub(:wait).with(nil)
    end

    it "invokes main api when using test methods" do
      CKey.stub(:grab_keyboard).with(@event_dispatcher)
      CKey.should_receive(:grab_keyboard).with(@event_dispatcher)
      CKey.test(@event_dispatcher).puts('a')
    end

    it "delegates key-related events to the EventDispatcher" do
      @event_dispatcher.should_receive(:key_press).with('a').once
      @event_dispatcher.should_receive(:key_release).with('a').once
      CKey.test(@event_dispatcher).puts('a')
    end

    it "informs about user's idleness" do
      @event_dispatcher.should_receive(:wait).with().twice
      CKey.test(@event_dispatcher).wait(2)
    end

    it "delegates all events" do
      @event_dispatcher.should_receive(:key_press).with('a').exactly(3).times
      @event_dispatcher.should_receive(:key_release).with('a').exactly(3).times
      @event_dispatcher.should_receive(:key_press).with('b').once
      @event_dispatcher.should_receive(:key_release).with('b').once
      CKey.test(@event_dispatcher).puts('a')
      CKey.test(@event_dispatcher).puts('a')
      CKey.test(@event_dispatcher).puts('b')
      CKey.test(@event_dispatcher).puts('a')
    end
  end

end
