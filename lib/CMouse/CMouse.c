#include "ruby.h"
#include <X11/Xlib.h>
#include <X11/extensions/XTest.h>

// Defining a space for information and references about the module to be stored internally
VALUE CMouse = Qnil;

// Prototype for the initialization method
void Init_CMouse();

VALUE method_get_mouse_x(VALUE self);
VALUE method_set_mouse_rel(VALUE self, VALUE x, VALUE y);
VALUE method_set_mouse_abs(VALUE self, VALUE x, VALUE y);

// The initialization method for this module
void Init_CMouse() {
  CMouse = rb_define_module("CMouse");
  rb_define_method(CMouse, "get_mouse_x", method_get_mouse_x, 0);
  rb_define_method(CMouse, "set_mouse_rel", method_set_mouse_rel, 2);
  rb_define_method(CMouse, "set_mouse_abs", method_set_mouse_abs, 2);
  initialize_screen();
}


Display *display;
int screen;
Window window;
unsigned int width, height;

int initialize_screen() {
  Window ret_window;
  int x, y;
  unsigned int border_width, depth;
  int keycode , is_down = 1;

  if (! (display = XOpenDisplay("")) ) {
    fprintf(stderr, "TouchKey: Cannot connect to display ...\n");
    return 1;
  }

  screen = DefaultScreen(display);
  window = RootWindow(display, screen);
  XGetGeometry( display, window, &ret_window, &x, &y, &width, &height, &border_width, &depth);

}

VALUE method_get_mouse_x(VALUE self) {
  int x = 10;
  return INT2NUM(x);
}

VALUE method_set_mouse_rel(VALUE self, VALUE x, VALUE y){
  XTestFakeRelativeMotionEvent(display, NUM2INT(x), NUM2INT(y), 0);
  XSync(display, 1);
}

VALUE method_set_mouse_abs(VALUE self, VALUE x, VALUE y){
  XTestFakeMotionEvent(display, screen, NUM2INT(x), NUM2INT(y), 0);
  XSync(display, 1);
}

