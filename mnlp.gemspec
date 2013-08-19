# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mnlp/version'

Gem::Specification.new do |spec|
  spec.name          = "mnlp"
  spec.version       = Mnlp::VERSION
  spec.authors       = ["Giorgos Tsiftsis"]
  spec.email         = ["giorgos.tsiftsis@skroutz.gr"]
  spec.description   = %q{Minimalistic Natural Language Processing}
  spec.summary       = %q{Minimalistic Natural Language Processing}
  spec.homepage      = "https://gitlab.skroutz.gr/mnlp/tree/master"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
