# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "ignoramos"
  spec.version       = "1.0.1"
  spec.authors       = ["Amos Chan"]
  spec.email         = ["amosschan@gmail.com"]
  spec.summary       = %q{A static site generator for blogs and microposts.}
  spec.description   = spec.summary
  spec.homepage      = "http://rubygems.org/gems/ignoramos"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
