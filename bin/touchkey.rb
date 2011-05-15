# LOAD_PATH is a ruby construct, works in a similar
# fashion as $PATH
$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"

require 'CMouse/CMouse'
require 'CKey/CKey'
require 'event_dispatcher'

CKey.grab_keyboard(EventDispatcher.new)
