require 'spec_helper'

require 'CMouse/CMouse'
include CMouse

describe "CMouse" do
  before(:all) do
  end
  describe ".set_mouse_abs" do
    it "sets mouse pointer to absolute position" do
      set_mouse_abs(10,20)
      get_mouse_x.should == 10
      get_mouse_y.should == 20
    end
  end
  describe ".set_mouse_rel" do
    it "sets mouse pointer relatively to previous position" do
      set_mouse_abs(10,20)
      set_mouse_rel(5,3)
      get_mouse_x.should == 15
      get_mouse_y.should == 23
    end
  end
  describe ".get_mouse_x" do
    pending
  end
end

