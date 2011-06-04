require 'spec_helper'
require 'event_dispatchers/base_dispatcher'

describe EventDispatchers::BaseDispatcher do
  describe "stubs methods for child classes" do
    it "raises error when key_press is invoked" do
      expect { subject.key_press('a') }.to raise_error(NotImplementedError)
    end

    it "raises error when key_release is invoked" do
      expect { subject.key_release('a') }.to raise_error(NotImplementedError)
    end

    it "raises error when wait is invoked" do
      expect { subject.wait() }.to raise_error(NotImplementedError)
    end
  end
end
