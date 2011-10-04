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
    # Event types for keypress / keyrelease types for different os. TODO:
    # refactor.
    def self.key_press
      if platform == 'osx'
        10
      elsif platform == 'linux'
        2
      end
    end
    def self.key_release
      if platform == 'osx'
        11
      elsif platform == 'linux'
        3
      end
    end

  end
end
