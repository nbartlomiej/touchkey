# LOAD_PATH is a ruby construct, works in a similar
# fashion as $PATH
$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"

require 'event_dispatchers/magnetic'
require 'CKey/CKey'

CKey.grab_keyboard(EventDispatchers::Magnetic.new)
