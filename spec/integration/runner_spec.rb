require 'spec_helper'

describe "runner" do
  it "should not raise anything" do
    CKey.stub(:grab_keyboard)
    expect { require 'bin/touchkey.rb' }.to_not raise_error
  end
end
