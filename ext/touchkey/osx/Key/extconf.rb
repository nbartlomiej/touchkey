require 'mkmf'

extension_name = 'Key'
dir_config(extension_name)

$LDFLAGS << ' -framework ApplicationServices -framework Foundation -framework Cocoa -framework Carbon'

create_makefile(extension_name)
