require 'spec_helper'

describe Touchkey::Key do

  it "invokes main api when using test methods" do
    Touchkey::Key.stub(:grab_keyboard).with(subject)
    Touchkey::Key.should_receive(:grab_keyboard).with(subject)
    Touchkey::Key.test(subject).puts('a')
  end

  describe "delegates events" do

    before do
      @dispatcher = Touchkey::EventDispatchers::SimpleDispatcher.new
    end

    it "delegates single-key events" do
      @dispatcher.should_receive(:signal).with('key_press', 'a').once
      @dispatcher.should_receive(:signal).with('key_release', 'a').once
      Touchkey::Key.test(@dispatcher).puts('a')
    end

    it "delegates all events" do
      @dispatcher.should_receive(:signal).with('key_press', 'a').exactly(3).times
      @dispatcher.should_receive(:signal).with('key_release', 'a').exactly(3).times
      @dispatcher.should_receive(:signal).with('key_press', 'b').once
      @dispatcher.should_receive(:signal).with('key_release', 'b').once
      Touchkey::Key.test(@dispatcher).puts('a')
      Touchkey::Key.test(@dispatcher).puts('a')
      Touchkey::Key.test(@dispatcher).puts('b')
      Touchkey::Key.test(@dispatcher).puts('a')
    end

    it "informs about user's idleness" do
      @dispatcher.should_receive(:signal).with('idle').twice
      Touchkey::Key.test(@dispatcher).idle(2)
    end

  end

end
