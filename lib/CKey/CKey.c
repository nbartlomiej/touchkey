#include "ruby.h"
#include <X11/Xlib.h>
#include <X11/Xutil.h>

// Defining a space for information and references about the module to be stored internally
VALUE CKey = Qnil;

// Prototype for the initialization method
void Init_CKey();

VALUE method_grab_keyboard(VALUE self, VALUE event_dispatcher);
VALUE method_push_test(VALUE self, VALUE key, VALUE event_type);
VALUE method_push_test_wait(VALUE self, VALUE ticks);

void grab_keyboard(void *args);

void Init_CKey() {
  CKey = rb_define_module("CKey");
  rb_define_singleton_method(CKey, "grab_keyboard", method_grab_keyboard, 1);
  rb_define_singleton_method(CKey, "push_test", method_push_test, 2);
  rb_define_singleton_method(CKey, "push_test_wait", method_push_test_wait, 1);
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

// is test key event triggered?
int test_queued = False;

// info about test key events
VALUE test_key;
VALUE test_event_type;

// receiving test key event from outer (ruby) libraries
VALUE method_push_test(VALUE self, VALUE key, VALUE event_type){
  test_queued     = True;
  test_key        = key;
  test_event_type = event_type;
}

// test wait triggered for n ticks of time
int test_wait_queued = 0;

// receiving test wait from outer (ruby) libraries
VALUE method_push_test_wait(VALUE self, VALUE ticks){
  test_wait_queued = NUM2INT(ticks);
}

void process_key_event(int keycode , int type){
  int quit_key = XKeysymToKeycode(display, quit_keysym);
  int super_key = XKeysymToKeycode(display, super_keysym);

  char * key = XKeysymToString( XKeycodeToKeysym(display, keycode, 0));
  switch(type) {

    case KeyPress:
      if (keycode == super_key){
        XGrabKeyboard(display, window, True, GrabModeAsync, GrabModeAsync, CurrentTime);
      } else {
        // send key_press to the event_dispatcher
        rb_funcall(event_dispatcher, rb_intern("signal"), 2, rb_str_new2("key_press"), rb_str_new2(key));
      }
      break;

    case KeyRelease:
      if (keycode == super_key){
        XUngrabKeyboard(display, CurrentTime);
      } else if (keycode == quit_key ){
        // the quit key has been released, exiting the loop
        should_release_keyboard = True ;
      } else {
        // send key_release to the event_dispatcher
        rb_funcall(event_dispatcher, rb_intern("signal"), 2, rb_str_new2("key_release"), rb_str_new2(key));
      }
      break;

    default:
      break;

  }
}

VALUE method_grab_keyboard(VALUE self, VALUE n_ed){

  // Two placeholders for the event loop; they will
  // either hold the actual value or a test value
  // depending on whether a test is queued for
  // execution (text_queued variable)
  int event_keycode;
  int event_type;

  int super_key = XKeysymToKeycode(display, super_keysym);
  unsigned int modifiers = 0; // ControlMask | ShiftMask;

  // updating the event_dispatcher value
  event_dispatcher = n_ed;

  XGrabKey(display, super_key, modifiers, window, False, GrabModeAsync, GrabModeAsync);
  XSelectInput(display, window, KeyPressMask | KeyReleaseMask);

  for (should_release_keyboard = False; should_release_keyboard == False; ) {

    if (test_queued == True || XPending(display) > 0){
      // there is an event to process
      if (test_queued == True){
        // just testing
        event_keycode = XKeysymToKeycode(display, XStringToKeysym(STR2CSTR(test_key)));
        event_type = NUM2INT(test_event_type);

        // doing only one keypress and quitting
        should_release_keyboard = True ;

        // marking the test as done
        test_queued = False;
      } else if (XPending(display)>0) {
        // it's the reall stuff, query the xlib
        XEvent event;
        XNextEvent(display, &event);
        event_keycode = event.xkey.keycode;
        event_type = event.type;
      }
      process_key_event(event_keycode, event_type);
    } else {
      if (test_wait_queued > 0){
        // oh, we're testing idleness
        if(--test_wait_queued==0){
          // for a fixed amount of ticks
          should_release_keyboard = True;
        }
      }
      // nothing happened
      rb_funcall(event_dispatcher, rb_intern("signal"), 1, rb_str_new2("wait"));
    }
  }
  XUngrabKey(display,super_key,modifiers,window);
}
