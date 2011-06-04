require 'rake/extensiontask'
require 'rake/testtask'

spec = Gem::Specification.new do |s|
  s.name = "string_internals"
  s.platform = Gem::Platform::RUBY
  s.extensions = FileList["ext/**/extconf.rb"]
end

Rake::ExtensionTask.new('string_internals', spec)

RUBY_VERSION =~ /\d.(\d).\d/
desc 'Run string internals tests'
Rake::TestTask.new(:test) do |t|
  t.pattern = "test/test_#{$1}*.rb"
  t.verbose = true
  t.warning = true
end
task :test => :compile

task :default => :test