require "touchkey/version"

require 'touchkey/event_dispatchers/base_dispatcher'
require 'touchkey/event_dispatchers/simple_dispatcher'
require 'touchkey/event_dispatchers/aggregator'
require 'touchkey/portable'

Touchkey::Portable::require_native 'touchkey/Key/Key'
Touchkey::Portable::require_native 'touchkey/Mouse/Mouse'

module Touchkey

end
