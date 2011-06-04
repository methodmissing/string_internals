require 'mkmf'
dir_config('string_internals')
$defs.push("-DRUBY19") if have_func('rb_thread_blocking_region')
$defs.push("-DRUBY18") if have_var('rb_trap_immediate', ['ruby.h', 'rubysig.h'])
$defs.push("-pedantic")
create_makefile('string_internals')