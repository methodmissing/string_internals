## WIP look into MRI Ruby's COW and buffer semantics for Strings ##

Boilerplate code for an upcoming blog post.

Tested on ruby-1.8.7-p334 (all 1.8.7 versions should be similar), but also compiles and runs on 1.9.2, but with it's own test suite as there's some implementation differences.

See [test/test_8string_internals.rb](https://github.com/methodmissing/string_internals/blob/master/test/test_8string_internals.rb) (1.8.7) and [test/test_9string_internals.rb](https://github.com/methodmissing/string_internals/blob/master/test/test_9string_internals.rb) (1.9) for now.

(c) 2011 Lourens Naudé (methodmissing)