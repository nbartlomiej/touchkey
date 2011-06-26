require 'mkmf'

extension_name = 'Mouse'
dir_config(extension_name)

if find_library("X11", "XOpenDisplay", "/usr/X11/lib", "/usr/X11R6/lib", "/usr/openwin/lib") and find_library("Xtst", "XTestFakeRelativeMotionEvent", "/usr/X11/lib", "/usr/X11R6/lib", "/usr/openwin/lib") and find_library("Xtst", "XTestFakeMotionEvent", "/usr/X11/lib", "/usr/X11R6/lib", "/usr/openwin/lib")
  create_makefile(extension_name)
else
  puts "Please install the missing packages!"
end
