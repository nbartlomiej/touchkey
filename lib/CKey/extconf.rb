require 'mkmf'

extension_name = 'CKey'
dir_config(extension_name)

if find_library("X11", "XOpenDisplay", "/usr/X11/lib", "/usr/X11R6/lib", "/usr/openwin/lib") and find_library("Xtst", "XKeysymToKeycode", "/usr/X11/lib", "/usr/X11R6/lib", "/usr/openwin/lib") and find_library("Xtst", "XTestFakeKeyEvent", "/usr/X11/lib", "/usr/X11R6/lib", "/usr/openwin/lib")
  create_makefile(extension_name)
else
  puts "Please install the missing packages!"
end
