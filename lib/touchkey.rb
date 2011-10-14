require "touchkey/version"

require 'touchkey/event_dispatchers/base_dispatcher'
require 'touchkey/event_dispatchers/simple_dispatcher'
require 'touchkey/event_dispatchers/aggregator'
require 'touchkey/portable'

# The order of these requires matters; should be: Mouse after Key. If Key is
# loaded before Mouse, the mouse spec fails. TODO: investivate.
Touchkey::Portable::require_native 'touchkey/Mouse/Mouse'
Touchkey::Portable::require_native 'touchkey/Key/Key'

module Touchkey

end
