require 'spec_helper'

# todo: add stubbing
describe "Compiler" do
  describe ".make_all" do
    it "compiles all modules" do
      Compiler.make_all.should == true
    end
  end
  describe ".make" do
    it "compiles an existing module" do
      Compiler.make("CMouse").should == true
    end
    it "fails to compile nonexistent module" do
      Compiler.make("Umm").should == false
    end
  end
end
