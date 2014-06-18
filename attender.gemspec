# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attender/version'

Gem::Specification.new do |spec|
  spec.name          = "attender"
  spec.version       = Attender::VERSION
  spec.authors       = ["foostan"]
  spec.email         = ["ks@fstn.jp"]
  spec.summary       = %q{Orchestration tool for server provisioning.}
  spec.description   = %q{Orchestration tool for server provisioning with Capistrano, running on Consul networks}
  spec.homepage      = "https://github.com/foostan/attender"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
