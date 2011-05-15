### Touchkey

Version 0.03 (early prototype)

It's an attempt to turn keyboard into a touchpad. It might not turn out to function exactly the same way, but should provide similar benefits (the ability to control a mouse pointer in a quick and precise way) with an additional one of not moving your hands off the keyboard.

Helpful links:
* Crating ruby extensions in C: http://www.rubyinside.com/how-to-create-a-ruby-extension-in-c-in-under-5-minutes-100.html
* Simple C program for manipulating pointer position in Linux: http://www.isv.uu.se/~ziemann/xevent/
* Introduction to ruby intperpreter's C internals: http://rhg.rubyforge.org/chapter02.html
* Another introduction to ruby's C-side: http://people.apache.org/~rooneg/talks/ruby-extensions/ruby-extensions.html

References:
* Another approach: http://www.topology.org/linux/xcursor.html

#### Running:

Dependencies:
1. Linux OS
2. libxtst-dev

1) bundle install
2) rspec spec (compiles everything and runs tests)
3) ruby ./bin/touchkey.rb

#### Usage:

Press Super key (a.k.a. windows key) and any letter/number key. Exit with Super-L.
