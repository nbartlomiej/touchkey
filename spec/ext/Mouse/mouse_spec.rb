require 'spec_helper'

require 'touchkey/portable'
Touchkey::Portable::require_native 'touchkey/Mouse/Mouse'

describe Touchkey::Mouse do

  before(:all) do
    # register the mouse's initial position
    @mouse_position = [Touchkey::Mouse.get_mouse_x, Touchkey::Mouse.get_mouse_y]
  end

  after(:all) do
    # restore the mouse's initial position
    Touchkey::Mouse.set_mouse_abs(*@mouse_position)
  end

  describe ".set_mouse_abs" do
    it "sets mouse pointer to absolute position" do
      Touchkey::Mouse.set_mouse_abs(10,20)
      Touchkey::Mouse.get_mouse_x.should == 10
      Touchkey::Mouse.get_mouse_y.should == 20
    end
  end
  describe ".get_mouse_x" do
    it "does not raise an error" do
      expect { subject.get_mouse_x }.to_not raise_error
    end
    it "is an integer" do
      subject.get_mouse_x.to_i.should == subject.get_mouse_x
    end
    it "is non-negative number" do
      subject.get_mouse_x.should be >= 0
    end
  end
  describe ".left_click" do
    pending
  end
end

