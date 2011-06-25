# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "touchkey/version"

Gem::Specification.new do |s|
  s.name        = "touchkey"
  s.version     = Touchkey::VERSION
  s.authors     = ["Bartlomiej Niemtur"]
  s.email       = ["nbartlomiej@gmail.com"]
  s.homepage    = "http://github.com/nbartlomiej/touchkey"
  s.summary     = %q{Touchscreen-style mouse control through keybaord}
  s.description = %q{Touchkey is an attempt to turn keyboard into a touchscreen-like input device. It allows to control the mouse pointer in a quick and precise way, without moving your hands off the keyboard.}

  # s.rubyforge_project = "touchkey"

  s.extensions = ["ext/CKey/extconf.rb", "ext/CMouse/extconf.rb"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version     = '1.8.7'
  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency('bundler', '~> 1.0')
  s.add_dependency('rspec', '~> 2.6.0')
  s.add_dependency('ruby-debug', '>= 0.10.4')
  s.add_dependency('rbx-require-relative', '>= 0.0.5')
end
