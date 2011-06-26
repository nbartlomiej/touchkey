require 'rbconfig'

module Touchkey
  module Portable
    def self.platform
      if RbConfig::CONFIG['host_os'] =~ /mswin|windows|cygwin/i
        'windows'
      elsif RbConfig::CONFIG['host_os'] =~ /darwin/
        'osx'
      else
        'linux'
      end
    end
    def self.require_native path
      require path.sub('touchkey/', "touchkey/#{platform}/")
    end
  end
end
