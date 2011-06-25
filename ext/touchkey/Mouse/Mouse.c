#include "ruby.h"
#include <X11/Xlib.h>
#include <X11/extensions/XTest.h>

// Defining a space for information and references about the module to be stored internally
VALUE Touchkey = Qnil;
VALUE Mouse = Qnil;

// Prototype for the initialization method
void Init_Mouse();

VALUE method_get_mouse_x(VALUE self);
VALUE method_get_mouse_y(VALUE self);
VALUE method_set_mouse_rel(VALUE self, VALUE x, VALUE y);
VALUE method_set_mouse_abs(VALUE self, VALUE x, VALUE y);
VALUE method_left_click(VALUE self);

// The initialization method for this module
void Init_Mouse() {
  Touchkey = rb_define_module("Touchkey");
  Mouse = rb_define_module_under(Touchkey, "Mouse");
  rb_define_singleton_method(Mouse, "get_mouse_x", method_get_mouse_x, 0);
  rb_define_singleton_method(Mouse, "get_mouse_y", method_get_mouse_y, 0);
  rb_define_singleton_method(Mouse, "set_mouse_rel", method_set_mouse_rel, 2);
  rb_define_singleton_method(Mouse, "set_mouse_abs", method_set_mouse_abs, 2);
  rb_define_singleton_method(Mouse, "left_click", method_left_click, 0);
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
  XEvent event;
  XQueryPointer(display, RootWindow(display, DefaultScreen(display)), &event.xbutton.root, &event.xbutton.window, &event.xbutton.x_root, &event.xbutton.y_root, &event.xbutton.x, &event.xbutton.y, &event.xbutton.state);
  return INT2NUM(event.xbutton.x_root);
}

VALUE method_get_mouse_y(VALUE self) {
  XEvent event;
  XQueryPointer(display, RootWindow(display, DefaultScreen(display)), &event.xbutton.root, &event.xbutton.window, &event.xbutton.x_root, &event.xbutton.y_root, &event.xbutton.x, &event.xbutton.y, &event.xbutton.state);
  return INT2NUM(event.xbutton.y_root);
}

VALUE method_set_mouse_rel(VALUE self, VALUE x, VALUE y){
  XTestFakeRelativeMotionEvent(display, NUM2INT(x), NUM2INT(y), 0);
  XSync(display, 1);
}

VALUE method_set_mouse_abs(VALUE self, VALUE x, VALUE y){
  // XWarpPointer(display, None, None, 0, 0, 0, 0, NUM2INT(x), NUM2INT(y));
  XTestFakeMotionEvent(display, screen, NUM2INT(x), NUM2INT(y), 0);
  XSync(display, 1);
}

/* Send Fake Key Event */  
VALUE method_left_click(VALUE self){
  XTestFakeButtonEvent (display, 1, True,  0);
  XSync(display, 1);
  XTestFakeButtonEvent (display, 1, False,  0);
  XSync(display, 1);
}

