# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ascii_data/version"

Gem::Specification.new do |s|
  s.name        = "ascii_data"
  s.version     = AsciiData::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["David Santoro"]
  s.email       = ["soulnafein@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Little library for importing ascii data files}
  s.description = %q{Just browse the specs and check it out}

  s.rubyforge_project = "ascii_data"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
