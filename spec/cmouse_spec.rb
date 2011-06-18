require 'spec_helper'

require 'CMouse/CMouse'

describe "CMouse" do

  before(:all) do
    # register the mouse's initial position
    @mouse_position = [CMouse.get_mouse_x, CMouse.get_mouse_y]
  end

  after(:all) do
    # restore the mouse's initial position
    CMouse.set_mouse_abs(*@mouse_position)
  end

  describe ".set_mouse_abs" do
    it "sets mouse pointer to absolute position" do
      CMouse.set_mouse_abs(10,20)
      CMouse.get_mouse_x.should == 10
      CMouse.get_mouse_y.should == 20
    end
  end
  describe ".set_mouse_rel" do
    it "sets mouse pointer relatively to previous position" do
      CMouse.set_mouse_abs(10,20)
      CMouse.set_mouse_rel(5,3)
      CMouse.get_mouse_x.should == 15
      CMouse.get_mouse_y.should == 23
    end
  end
  describe ".get_mouse_x" do
    pending
  end
end

