require 'mkmf'

extension_name = 'Mouse'
dir_config(extension_name)

$LDFLAGS << ' -framework ApplicationServices -framework Foundation -framework Cocoa'

create_makefile(extension_name)
