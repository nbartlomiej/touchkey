#import <Ruby/Ruby.h>
#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>
#import <Cocoa/Cocoa.h>

// Defining a space for information and references about the module to be stored internally
VALUE Touchkey = Qnil;
VALUE Key = Qnil;

// Prototype for the initialization method
void Init_Key();

VALUE method_grab_keyboard(VALUE self, VALUE event_dispatcher);
VALUE method_push_test(VALUE self, VALUE key, VALUE event_type);
VALUE method_push_test_idle(VALUE self, VALUE ticks);

void grab_keyboard(void *args);

void Init_Key() {
  Touchkey = rb_define_module("Touchkey");
  Key = rb_define_module_under(Touchkey, "Key");
  rb_define_singleton_method(Key, "grab_keyboard", method_grab_keyboard, 1);
  rb_define_singleton_method(Key, "push_test", method_push_test, 2);
  rb_define_singleton_method(Key, "push_test_idle", method_push_test_idle, 1);
  initialize_screen();
}

// TODO: Display *display; // X display
// TODO: int screen;       // screen number
// TODO: Window window;    // X window

// the 'super' key, toggles keyboard grab by touchkey
// int super_keysym = // TODO: XK_Super_L;

// int quit_keysym = // TODO: XK_L;

// global bool variable indicating whether the
// keyboard-grabbing event loop should hit break
int should_release_keyboard = false ;

// reference to the ruby object responsible for
// procesing key events
VALUE event_dispatcher;

// NSEvent returns y coordinates relatively to the BOTTOM
// edge of the screen (and not to the top edge); height_offset
// variable helps in doing the conversion.
int height_offset;

int initialize_screen() {

  CGDirectDisplayID display = CGMainDisplayID();
  height_offset = CGDisplayPixelsHigh (display);

  /*
  Window ret_window;
  int x, y;
  unsigned int border_width, depth;

  if (! (display = // TODO: XOpenDisplay("")) ) {
    fprintf(stderr, "TouchKey: Cannot connect to display ...\n");
    return 1;
  }

  screen = // TODO: DefaultScreen(display);
  window = // TODO: RootWindow(display, screen);
  unsigned int width, height; // placeholders, thrown away asap
  // TODO: XGetGeometry( display, window, &ret_window, &x, &y, &width, &height, &border_width, &depth);
  */
}

// is test key event triggered?
int test_queued = false;

// info about test key events
VALUE test_key;
VALUE test_event_type;

// receiving test key event from outer (ruby) libraries
VALUE method_push_test(VALUE self, VALUE key, VALUE event_type){
  test_queued     = true;
  test_key        = key;
  test_event_type = event_type;
}

// test idle triggered for n ticks of time
int test_idle_queued = 0;

// receiving test idle from outer (ruby) libraries
VALUE method_push_test_idle(VALUE self, VALUE ticks){
  test_idle_queued = NUM2INT(ticks);
}

void process_key_event(int keycode , int type){
  int quit_key = 1; // TODO: XKeysymToKeycode(display, quit_keysym);
  int super_key = 1; // TODO: XKeysymToKeycode(display, super_keysym);

  char * key = 1; // TODO: XKeysymToString( XKeycodeToKeysym(display, keycode, 0));
  switch(type) {

    case 1: // TODO: KeyPress:
      if (keycode == super_key){
        // TODO: XGrabKeyboard(display, window, True, GrabModeAsync, GrabModeAsync, CurrentTime);
      } else {
        // send key_press to the event_dispatcher
        rb_funcall(event_dispatcher, rb_intern("signal"), 2, rb_str_new2("key_press"), rb_str_new2(key));
      }
      break;

    case 2: // TODO: KeyRelease:
      if (keycode == super_key){
        // TODO: XUngrabKeyboard(display, CurrentTime);
      } else if (keycode == quit_key ){
        // the quit key has been released, exiting the loop
        should_release_keyboard = true ;
      } else {
        // send key_release to the event_dispatcher
        rb_funcall(event_dispatcher, rb_intern("signal"), 2, rb_str_new2("key_release"), rb_str_new2(key));
      }
      break;

    default:
      break;

  }
}

VALUE method_grab_keyboard(VALUE self, VALUE new_event_dispatcher){

  // Two placeholders for the event loop; they will
  // either hold the actual value or a test value
  // depending on whether a test is queued for
  // execution (text_queued variable)
  int event_keycode;
  int event_type;

  // int super_key = // TODO: XKeysymToKeycode(display, super_keysym);
  // unsigned int modifiers = 0; // ControlMask | ShiftMask;

  // updating the event_dispatcher value
  event_dispatcher = new_event_dispatcher;

  // TODO: XGrabKey(display, super_key, modifiers, window, False, GrabModeAsync, GrabModeAsync);
  // TODO: XSelectInput(display, window, KeyPressMask | KeyReleaseMask);

  for (should_release_keyboard = false; should_release_keyboard == false; ) {

    if (test_queued == true ){ //|| // TODO: XPending(display) > 0){
      // there is an event to process
      if (test_queued == true){
        // just testing
        event_keycode = // TODO: XKeysymToKeycode(display, XStringToKeysym(STR2CSTR(test_key)));
        event_type = NUM2INT(test_event_type);

        // doing only one keypress and quitting
        should_release_keyboard = true ;

        // marking the test as done
        test_queued = false;
      } else if (false){// TODO: XPending(display)>0) {
        // it's the reall stuff, query the xlib
        // TODO: XEvent event;
        // TODO: XNextEvent(display, &event);
        // event_keycode = event.xkey.keycode;
        // event_type = event.type;
      }
      process_key_event(event_keycode, event_type);
    } else {
      if (test_idle_queued > 0){
        // oh, we're testing idleness
        if(--test_idle_queued==0){
          // for a fixed amount of ticks
          should_release_keyboard = true;
        }
      }
      // nothing happened
      rb_funcall(event_dispatcher, rb_intern("signal"), 1, rb_str_new2("idle"));
    }
  }
  // TODO: XUngrabKey(display,super_key,modifiers,window);
}
