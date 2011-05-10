#include "ruby.h"
#include <X11/Xlib.h>

// Defining a space for information and references about the module to be stored internally
VALUE CKey = Qnil;

// Prototype for the initialization method
void Init_CKey();

VALUE method_set_event_dispatcher(VALUE self, VALUE event_dispatcher);
VALUE method_simulate_keypress(VALUE self, VALUE keycode);

void Init_CKey() {
  CKey = rb_define_module("CKey");
  rb_define_method(CKey, "set_event_dispatcher", method_set_event_dispatcher, 1);
  rb_define_method(CKey, "simulate_keypress", method_simulate_keypress, 1);
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

VALUE event_dispatcher;

VALUE method_set_event_dispatcher(VALUE self, VALUE n_ed){
  event_dispatcher = n_ed;
}

VALUE method_simulate_keypress(VALUE self, VALUE keycode){
  XTestFakeKeyEvent(display, NUM2INT(keycode), True, 0);
  XTestFakeKeyEvent(display, NUM2INT(keycode), False, 0);
}
