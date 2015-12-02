# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lydia/version'

Gem::Specification.new do |spec|
  spec.name          = 'lydia'
  spec.version       = Lydia::VERSION
  spec.authors       = ['Mirko Mignini']
  spec.email         = ['mirko.mignini@gmail.com']

  spec.summary       = %q{Lightweight, fast and easy to use small ruby web framework.}
  spec.description   = %q{Lightweight, fast and easy to use small ruby web framework.}
  spec.homepage      = 'https://github.com/MirkoMignini/lydia'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split('\x0').reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split('\n')
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coveralls'

  spec.add_dependency 'rake'
  spec.add_dependency 'tilt'
end
