require 'spec_helper'

describe Touchkey::EventDispatchers::Aggregator do

  before do
    @dispatcher = Touchkey::EventDispatchers::Aggregator.new
  end

  it "swallows uniform events" do
    @dispatcher.should_receive(:key_press).with('a').once
    @dispatcher.should_receive(:idle).with().exactly(5).times
    @dispatcher.should_receive(:key_release).with('a').once
    Touchkey::Key.test(@dispatcher).puts('a')
    Touchkey::Key.test(@dispatcher).puts('a')
    Touchkey::Key.test(@dispatcher).puts('a')
    Touchkey::Key.test(@dispatcher).idle(1)
  end
end

