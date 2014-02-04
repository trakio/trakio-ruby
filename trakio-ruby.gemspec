# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trakio/version'

Gem::Specification.new do |spec|
  spec.name          = "trakio-ruby"
  spec.version       = Trakio::VERSION
  spec.authors       = ["Matthew Spence", "Tobie Warburton"]
  spec.email         = ["matt@trak.io", "tobie.warburton@gmail.com"]
  spec.description   = "Official trak.io ruby library for Ruby"
  spec.summary       = "Official trak.io ruby library for Ruby"
  spec.homepage      = "https://github.com/trakio/trakio-ruby"
  spec.license       = "Apache 2.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'fuubar'

  spec.add_dependency 'rest_client'
  spec.add_dependency 'pry'
end
