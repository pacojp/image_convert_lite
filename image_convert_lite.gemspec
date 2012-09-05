# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "image_convert_lite/version"

Gem::Specification.new do |s|
  s.name        = "image_convert_lite"
  s.version     = ImageConvertLite::VERSION
  s.authors     = ["pacojp"]
  s.email       = ["paco.jp@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{imagemagick proxy}
  s.description = %q{imagemagick proxy}

  s.rubyforge_project = "image_convert_lite"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
