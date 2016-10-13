# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lydia/version'

Gem::Specification.new do |spec|
  spec.name          = 'lydia'
  spec.version       = Lydia::VERSION
  spec.authors       = ['Mirko Mignini']
  spec.email         = ['mirko.mignini@gmail.com']

  spec.summary       = 'Lightweight, fast and easy to use small ruby web framework.'
  spec.description   = 'Lightweight, fast and easy to use small ruby web framework.'
  spec.homepage      = 'https://github.com/MirkoMignini/lydia'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.2.2'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'haml'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'

  spec.add_dependency 'rack', '~> 2.0.1'
  spec.add_dependency 'tilt'
end
