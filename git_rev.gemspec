# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git_rev/version'

Gem::Specification.new do |spec|
  spec.name          = "git_rev"
  spec.version       = GitRev::VERSION
  spec.authors       = ["Justin Talbott"]
  spec.email         = ["justin@waymondo.com"]
  spec.description   = %q{Easily refer to your Rails app's current git revision.}
  spec.summary       = %q{Exposes the git head SHA to your Rails app.}
  spec.homepage      = "https://github.com/waymondo/git_rev"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'railties'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 0'
  spec.add_dependency 'rails', '>= 3.2', '< 5.0'
end
