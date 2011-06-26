#import <Ruby/Ruby.h>

#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>
#import <Cocoa/Cocoa.h>


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


int initialize_screen() {
  // NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  // NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
}

VALUE method_get_mouse_x(VALUE self) {
  NSPoint mouseLoc;
  mouseLoc = [NSEvent mouseLocation];
  return INT2NUM(mouseLoc.x);
//   XEvent event;
//   XQueryPointer(display, RootWindow(display, DefaultScreen(display)), &event.xbutton.root, &event.xbutton.window, &event.xbutton.x_root, &event.xbutton.y_root, &event.xbutton.x, &event.xbutton.y, &event.xbutton.state);
//   return INT2NUM(event.xbutton.x_root);
}

VALUE method_get_mouse_y(VALUE self) {
  NSPoint mouseLoc;
  mouseLoc = [NSEvent mouseLocation];
  return INT2NUM(mouseLoc.y);
//   XEvent event;
//   XQueryPointer(display, RootWindow(display, DefaultScreen(display)), &event.xbutton.root, &event.xbutton.window, &event.xbutton.x_root, &event.xbutton.y_root, &event.xbutton.x, &event.xbutton.y, &event.xbutton.state);
//   return INT2NUM(event.xbutton.y_root);
}

VALUE method_set_mouse_rel(VALUE self, VALUE x, VALUE y){
//   XTestFakeRelativeMotionEvent(display, NUM2INT(x), NUM2INT(y), 0);
//   XSync(display, 1);
}

VALUE method_set_mouse_abs(VALUE self, VALUE x, VALUE y){
  CGPoint pt;
  pt.x = NUM2INT(x);
  pt.y = NUM2INT(y);
  CGPostMouseEvent( pt, 1, 1, 0 );
}

// to avoid deprecation warnings, use:
// void PostMouseEvent(CGMouseButton button, CGEventType type, const CGPoint point)
// {
//   CGEventRef theEvent = CGEventCreateMouseEvent(NULL, type, point, button);
//   CGEventSetType(theEvent, type);
//   CGEventPost(kCGHIDEventTap, theEvent);
//   CFRelease(theEvent);
// }

/* Send Fake Key Event */  
VALUE method_left_click(VALUE self){
//   XTestFakeButtonEvent (display, 1, True,  0);
//   XSync(display, 1);
//   XTestFakeButtonEvent (display, 1, False,  0);
//   XSync(display, 1);
}

