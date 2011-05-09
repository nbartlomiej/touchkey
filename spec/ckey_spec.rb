require 'spec_helper'

require 'CKey/CKey'
include CKey

describe "CKey" do

  describe ".set_event_dispatcher" do
    ed = EventDispatcher.new
    set_event_dispatcher(ed).should = true
  end

  describe "redirect event to the EventDispatcher" do
    ed = EventDispatcher.new
    set_event_dispatcher(ed).should = true
    ed.stubs(:key_press).with('A').returns(true)
    simulate_keypress('A')
  end

end
