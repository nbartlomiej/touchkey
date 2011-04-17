### Touchkey

It's an attempt to turn keyboard into a touchpad. It might not turn out to function exactly the same way, but should provide similar benefits (the ability to control a mouse pointer in a quick and precise way) with an additional one of not moving your hands off the keyboard.

Helpful links:
* Crating ruby extensions in C: http://www.rubyinside.com/how-to-create-a-ruby-extension-in-c-in-under-5-minutes-100.html
* Simple C program for manipulating pointer position in Linux: http://www.isv.uu.se/~ziemann/xevent/

References:
* Another approach: http://www.topology.org/linux/xcursor.html

#### Running:

Dependencies:
1. Linux OS
2. libxtst-dev

I. In CMouse directory, execute:
  1) ruby extconf.rb
  2) make

II. In root directory, execute:
  1) ruby touchkey.rb
