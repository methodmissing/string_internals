#include "ruby.h"

/* MRI string.c */
#define STR_ASSOC   FL_USER3
#define STR_NOCAPA  (ELTS_SHARED|STR_ASSOC)

/* Differences in string object meta between 1.8 and 1.9 */
#ifdef RUBY18
#define RSTRING_CAPA(str) RSTRING(str)->aux.capa
#define RSTRING_SHARED(str) RSTRING(str)->aux.shared
#else
#define RSTRING_CAPA(str) RSTRING(str)->as.heap.aux.capa
#define RSTRING_SHARED(str) RSTRING(str)->as.heap.aux.shared
#endif

static VALUE
rb_s_str_buffer(VALUE str, VALUE size){
    Check_Type(size, T_FIXNUM);
    return rb_str_buf_new(NUM2LONG(size));
}

static VALUE
rb_str_capa(VALUE str){
    if FL_TEST(str, STR_NOCAPA) return INT2FIX(0);
    return LONG2FIX(RSTRING_CAPA(str));
}

static VALUE
rb_str_shared(VALUE str){
    if (!FL_TEST(str, ELTS_SHARED)) return Qnil;
    return RSTRING_SHARED(str);
}

static VALUE
rb_str_shared_p(VALUE str){
    return FL_TEST(str, ELTS_SHARED) ? Qtrue : Qfalse;
}

static VALUE
rb_str_assoc_p(VALUE str){
    return FL_TEST(str, STR_ASSOC) ? Qtrue : Qfalse;
}

static VALUE
rb_str_obj_size(VALUE str){
    if FL_TEST(str, STR_NOCAPA) return LONG2FIX(sizeof(struct RString) + RSTRING_LEN(str) + 1);
    return LONG2FIX(sizeof(struct RString) + RSTRING_CAPA(str) + 1);
}

void
Init_string_internals()
{
    rb_define_singleton_method(rb_cString, "buffer", rb_s_str_buffer, 1);
    rb_define_method(rb_cString, "capacity", rb_str_capa, 0);
    rb_define_method(rb_cString, "shared", rb_str_shared, 0);
    rb_define_method(rb_cString, "shared?", rb_str_shared_p, 0);
    rb_define_method(rb_cString, "associated?", rb_str_assoc_p, 0);
    rb_define_method(rb_cString, "obj_size", rb_str_obj_size, 0);
}