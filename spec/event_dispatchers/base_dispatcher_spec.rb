require 'spec_helper'
require 'event_dispatchers/base_dispatcher'

describe EventDispatchers::BaseDispatcher do
  describe "translates signals directly to method calls" do
    it "processes key_press" do
      subject.stub(:key_press).with('a')
      subject.should_receive(:key_press).with('a').once
      subject.signal('key_press', 'a')
    end
    it "processes key_release" do
      subject.stub(:key_press).with('a')
      subject.should_receive(:key_press).with('a').once
      subject.signal('key_press', 'a')
    end
    it "processes idle" do
      subject.stub(:idle).with()
      subject.should_receive(:idle).with().once
      subject.signal('idle')
    end
    it "sends complete signal sequences" do
      subject.stub(:key_press).with('a')
      subject.stub(:key_press).with('b')
      subject.should_receive(:key_press).with('a').exactly(3).times
      subject.should_receive(:key_press).with('b').once
      subject.signal('key_press', 'a')
      subject.signal('key_press', 'a')
      subject.signal('key_press', 'b')
      subject.signal('key_press', 'a')
    end
  end
  describe "stubs methods for child classes" do
    it "raises error when key_press is invoked" do
      expect { subject.key_press('a') }.to raise_error(NotImplementedError)
    end

    it "raises error when key_release is invoked" do
      expect { subject.key_release('a') }.to raise_error(NotImplementedError)
    end

    it "raises error when idle is invoked" do
      expect { subject.idle() }.to raise_error(NotImplementedError)
    end
  end
end
