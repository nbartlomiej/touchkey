#include "ruby.h"
#include <X11/Xlib.h>
#include <X11/Xutil.h>

// Defining a space for information and references about the module to be stored internally
VALUE CKey = Qnil;

// Prototype for the initialization method
void Init_CKey();

VALUE method_grab_keyboard(VALUE self, VALUE event_dispatcher);
VALUE method_push_test(VALUE self, VALUE key, VALUE event_type);

void grab_keyboard(void *args);

void Init_CKey() {
  CKey = rb_define_module("CKey");
  rb_define_singleton_method(CKey, "grab_keyboard", method_grab_keyboard, 1);
  rb_define_singleton_method(CKey, "push_test", method_push_test, 2);
  initialize_screen();
}

Display *display; // X display
int screen;       // screen number
Window window;    // X window

// the 'super' key, toggles keyboard grab by touchkey
int super_keysym = XK_Super_L;

int quit_keysym = XK_L;

// global bool variable indicating whether the
// keyboard-grabbing event loop should hit break
int should_release_keyboard = False ;

// reference to the ruby object responsible for
// procesing key events
VALUE event_dispatcher;

int initialize_screen() {
  Window ret_window;
  int x, y;
  unsigned int border_width, depth;

  if (! (display = XOpenDisplay("")) ) {
    fprintf(stderr, "TouchKey: Cannot connect to display ...\n");
    return 1;
  }

  screen = DefaultScreen(display);
  window = RootWindow(display, screen);
  unsigned int width, height; // placeholders, thrown away asap
  XGetGeometry( display, window, &ret_window, &x, &y, &width, &height, &border_width, &depth);
}

int test_queued = False;
VALUE test_key;
VALUE test_event_type;

VALUE method_push_test(VALUE self, VALUE key, VALUE event_type){
  test_queued = True;
  test_key = key;
  test_event_type = event_type;
}


VALUE method_grab_keyboard(VALUE self, VALUE n_ed){

  // Two placeholders for the event loop; they will
  // either hold the true value or a test value
  // depending on whether a test_keycode is set
  int event_keycode;
  int event_type;


  // updating the event_dispatcher value
  event_dispatcher = n_ed;

  unsigned int modifiers = 0; // ControlMask | ShiftMask;

  int super_key= XKeysymToKeycode(display, super_keysym);
  int quit_key= XKeysymToKeycode(display, quit_keysym);

  XGrabKey(display, super_key, modifiers, window, False, GrabModeAsync, GrabModeAsync);

  XSelectInput(display, window, KeyPressMask | KeyReleaseMask);

  should_release_keyboard = False ;
  while (should_release_keyboard == False ) {

    if (test_queued == True){
      // just testing

      event_keycode = XKeysymToKeycode(display, XStringToKeysym(STR2CSTR(test_key)));
      event_type = NUM2INT(test_event_type);

      // doing only one keypress and quitting
      should_release_keyboard = True ;

      // marking the test as done
      test_queued = False;
    } else {
      // it's the reall stuff, query the xlib

      XEvent event;
      XNextEvent(display, &event);
      event_keycode = event.xkey.keycode;
      event_type = event.type;
    }
    char * key = XKeysymToString( XKeycodeToKeysym(display, event_keycode, 0));
    switch(event_type) {

      case KeyPress:
        if (event_keycode == super_key){
          XGrabKeyboard(display, window, True, GrabModeAsync, GrabModeAsync, CurrentTime);
        } else {
          // send key_press to the event_dispatcher
          rb_funcall(event_dispatcher, rb_intern("key_press"), 1, rb_str_new2(key));
        }
        break;

      case KeyRelease:
        if (event_keycode == super_key){
          XUngrabKeyboard(display, CurrentTime);
        } else if (event_keycode == quit_key ){
          // the quit key has been released, exiting the loop
          should_release_keyboard = True ;
        } else {
          // send key_release to the event_dispatcher
          rb_funcall(event_dispatcher, rb_intern("key_release"), 1, rb_str_new2(key));
        }
        break;

      default:
        break;

    }
  }
  XUngrabKey(display,super_key,modifiers,window);
}
