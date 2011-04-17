#include "ruby.h"

// Defining a space for information and references about the module to be stored internally
VALUE CMouse = Qnil;

// Prototype for the initialization method
void Init_CMouse();

VALUE method_get_mouse_x(VALUE self);

// The initialization method for this module
void Init_CMouse() {
  CMouse = rb_define_module("CMouse");
  rb_define_method(CMouse, "get_mouse_x", method_get_mouse_x, 0);
}

VALUE method_get_mouse_x(VALUE self) {
  int x = 10;
  return INT2NUM(x);
}

