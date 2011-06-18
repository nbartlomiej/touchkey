require 'spec_helper'

require 'event_dispatchers/simple_dispatcher'

require 'CKey/CKey'
require 'helpers/ckey_helper'

describe "runner" do
  it "should not raise anything" do
    CKey.stub(:grab_keyboard)
    expect { require 'bin/touchkey.rb' }.to_not raise_error
  end
end
