require 'touchkey/portable'
describe Touchkey::Portable do
  describe '.platform' do
    it "recognises osx system" do
      RbConfig::CONFIG = {'host_os' => 'darwin-x.x.x'}
      subject.platform.should == 'osx'
    end
    it "recognises linux system" do
      RbConfig::CONFIG = {'host_os' => 'linux-x.x.x'}
      subject.platform.should == 'linux'
    end
    it "recognises windows system" do
      RbConfig::CONFIG = {'host_os' => 'windows-x.x.x'}
      subject.platform.should == 'windows'
    end
  end
  describe 'require_native' do
    it 'prefixes require path with os name' do
      pending
    end
  end
end
