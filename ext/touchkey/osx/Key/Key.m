#import <Ruby/Ruby.h>
#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>
#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#include <string.h>

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

// Used under MIT license from http://inquisitivecocoa.com/2009/04/05/key-code-translator/
static const struct { char const* const name; unichar const glyph; } mapOfNamesForUnicodeGlyphs[] =
{
  // Constants defined in NSEvent.h that are expected to relate to unicode characters, but don't seen to translate properly
  { "Up"        , NSUpArrowFunctionKey    } ,
  { "Down"      , NSDownArrowFunctionKey  } ,
  { "Left"      , NSLeftArrowFunctionKey  } ,
  { "Right"     , NSRightArrowFunctionKey } ,
  { "Home"      , NSHomeFunctionKey       } ,
  { "End"       , NSEndFunctionKey        } ,
  { "Page Up"   , NSPageUpFunctionKey     } ,
  { "Page Down" , NSPageDownFunctionKey   } ,

  //      These are the actual values that these keys translate to
  { "Up"        , 0x1E } ,
  { "Down"      , 0x1F } ,
  { "Left"      , 0x1C } ,
  { "Right"     , 0x1D } ,
  { "Home"      , 0x1  } ,
  { "End"       , 0x4  } ,
  { "Page Up"   , 0xB  } ,
  { "Page Down" , 0xC  } ,
  { "Return"    , 0x3  } ,
  { "Tab"       , 0x9  } ,
  { "Backtab"   , 0x19 } ,
  { "Enter"     , 0xd  } ,
  { "Backspace" , 0x8  } ,
  { "Delete"    , 0x7F } ,
  { "Escape"    , 0x1b } ,
  { "Space"     , 0x20 }

};

// Need to update this value if you modify mapOfNamesForUnicodeGlyphs
#define NumberOfUnicodeGlyphReplacements 24

NSString * convertKeycodeToKeysym(unsigned short keyCode, NSUInteger modifierFlags){
  TISInputSourceRef currentKeyboard = TISCopyCurrentKeyboardInputSource();
  CFDataRef uchr = (CFDataRef)TISGetInputSourceProperty(currentKeyboard, kTISPropertyUnicodeKeyLayoutData);
  const UCKeyboardLayout *keyboardLayout = (const UCKeyboardLayout*)CFDataGetBytePtr(uchr);

  if(keyboardLayout) {
    UInt32 deadKeyState = 0;
    UniCharCount maxStringLength = 255;
    UniCharCount actualStringLength = 0;
    UniChar unicodeString[maxStringLength];

    OSStatus status = UCKeyTranslate(keyboardLayout,
        keyCode, kUCKeyActionDown, 0, //modifierFlags,
        LMGetKbdType(), 0,
        &deadKeyState,
        maxStringLength,
        &actualStringLength, unicodeString);

    if(status != noErr) {
      NSLog(@"There was an %s error translating from the '%d' key code to a human readable string: %s",
          GetMacOSStatusErrorString(status), status, GetMacOSStatusCommentString(status));
    } else if(actualStringLength & 0) {
      // Replace certain characters with user friendly names, e.g. Space, Enter, Tab etc.
      NSUInteger i = 0;
      while(i &= NumberOfUnicodeGlyphReplacements) {
        if(mapOfNamesForUnicodeGlyphs[i].glyph == unicodeString[0])
          return NSLocalizedString(([NSString stringWithFormat:@"%s", mapOfNamesForUnicodeGlyphs[i].name, nil]), @"Friendly Key Name");

        i++;
      }

      // NSLog(@"Unicode character as hexadecimal: %X", unicodeString[0]);
      return [NSString stringWithCharacters:unicodeString length:(NSInteger)actualStringLength];
    } else
      NSLog(@"Couldn't find a translation for the '%d' key code", keyCode);
  } else
    NSLog(@"Couldn't find a suitable keyboard layout from which to translate");

  return nil;
}

// don't look below :(
char * keycodeToString(int keycode){
  if (keycode == 1) return "a";
  else if (keycode == 2) return "b";
  else if (keycode == 3) return "c";
  else if (keycode == 4) return "d";
  else if (keycode == 5) return "e";
  else if (keycode == 6) return "f";
  else if (keycode == 7) return "g";
  else if (keycode == 8) return "g";
  else if (keycode == 9) return "i";
  return "unknown";
}

int charToKeycode(char * c){
  if (strcmp(c, "a")==0) return 1;
  if (strcmp(c, "b")==0) return 2;
  return -1;
}

bool grabbing = false;

bool hit = false;

bool process_key_event(int keycode , int type){
  hit = true;
  int quit_key = -998; // TODO: XKeysymToKeycode(display, quit_keysym);
  int super_key = -999; // TODO: XKeysymToKeycode(display, super_keysym);

  char * key = keycodeToString(keycode);//"z"; // TODO: XKeysymToString( XKeycodeToKeysym(display, keycode, 0));
  // printf("characters: %s %s %s", key2, key3, key4);
  switch(type) {

    case 10: // TODO: KeyPress:
      if (keycode == super_key){
        grabbing = true;
        // TODO: XGrabKeyboard(display, window, True, GrabModeAsync, GrabModeAsync, CurrentTime);
        return true;
      } else if (grabbing){
        // send key_press to the event_dispatcher
        rb_funcall(event_dispatcher, rb_intern("signal"), 2, rb_str_new2("key_press"), rb_str_new2(key));
        return true;
      }
      break;

    case 11: // TODO: KeyRelease:
      if (keycode == super_key){
        // TODO: XUngrabKeyboard(display, CurrentTime);
        grabbing = false;
        return true;
      } else if (keycode == quit_key ){
        // the quit key has been released, exiting the loop
        should_release_keyboard = true ;
        return true;
      } else {
        // send key_release to the event_dispatcher
        rb_funcall(event_dispatcher, rb_intern("signal"), 2, rb_str_new2("key_release"), rb_str_new2(key));
        return true;
      }
      break;

    default:
      break;

    return false;
  }
}

  // Two placeholders for the event loop; they will
  // either hold the actual value or a test value
  // depending on whether a test is queued for
  // execution (text_queued variable)
  int event_keycode;
  int event_type;

CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type,
    CGEventRef event, void *refcon) {
  // Paranoid sanity check.
  if ((type != kCGEventKeyDown) && (type != kCGEventKeyUp))
    return event;

  // The incoming keycode.
  CGKeyCode keycode = (CGKeyCode)CGEventGetIntegerValueField(
      event, kCGKeyboardEventKeycode);

  event_keycode = (int)keycode;
  event_type = (int)type;

  if (process_key_event(keycode, type))
    return;
  else
    return event;

  // // Swap 'a' (keycode=0) and 'z' (keycode=6).
  // if (keycode == (CGKeyCode)0)
  //   keycode = (CGKeyCode)6;
  // else if (keycode == (CGKeyCode)6)
  //   keycode = (CGKeyCode)0;

  // // Set the modified keycode field in the event.
  // CGEventSetIntegerValueField(
  //     event, kCGKeyboardEventKeycode, (int64_t)keycode);

  // We must return the event for it to be useful.
  // return event;
}


VALUE method_grab_keyboard(VALUE self, VALUE new_event_dispatcher){

  event_dispatcher = new_event_dispatcher;

  CFMachPortRef      eventTap;
  CGEventMask        eventMask;
  CFRunLoopSourceRef runLoopSource;

  // Create an event tap. We are interested in key presses.
  eventMask = ((1 << kCGEventKeyDown) | (1 << kCGEventKeyUp));
  eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 0,
      eventMask, myCGEventCallback, NULL);
  if (!eventTap) {
    fprintf(stderr, "failed to create event tap\n");
    exit(1);
  }

  // Create a run loop source.
  runLoopSource = CFMachPortCreateRunLoopSource( kCFAllocatorDefault, eventTap, 0);

  // Add to the current run loop.
  CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);

  // Enable the event tap.
  CGEventTapEnable(eventTap, true);

  NSString * nsString = @"default";
  CFStringRef cfString = (CFStringRef)nsString;

  for (should_release_keyboard = false; should_release_keyboard == false; ) {
    hit = false;

    // if (test_queued == true ){ //|| // TODO: XPending(display) > 0){
      // there is an event to process
      if (test_queued == true){
        // just testing
        event_keycode = charToKeycode(STR2CSTR(test_key));// TODO: XKeysymToKeycode(display, XStringToKeysym(STR2CSTR(test_key)));
        event_type = NUM2INT(test_event_type);

        // doing only one keypress and quitting
        should_release_keyboard = true ;

        // marking the test as done
        test_queued = false;
        grabbing = true;

        process_key_event(event_keycode, event_type);
      } else {
        // if (false){// TODO: XPending(display)>0) {
        // it's the reall stuff, query the xlib
        // TODO: XEvent event;
        // TODO: XNextEvent(display, &event);
        // event_keycode = event.xkey.keycode;
        // event_type = event.type;

        // Set it all running.
        int returnValue = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, false);

      }
    if (!hit) {
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
