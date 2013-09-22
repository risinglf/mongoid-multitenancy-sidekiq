# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid-multitenancy/sidekiq/version'

Gem::Specification.new do |spec|
  spec.name          = 'mongoid-multitenancy-sidekiq'
  spec.version       = Mongoid::Multitenancy::Sidekiq::VERSION
  spec.authors       = ['Luca Ferrrari']
  spec.email         = ['risinglf@gmail.com']
  spec.description   = %q{Enable Multi-tenant supported jobs to work with Sidekiq background workers}
  spec.summary       = %q{Sidekiq support for Mongoid::Multitenancy}
  spec.homepage      = 'https://github.com/risinglf/mongoid-multitenancy-sidekiq'
  spec.license       = 'APACHE 2'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency('rake', '~> 10.0')
  spec.add_development_dependency('rspec', '~> 2.12')
  spec.add_development_dependency('yard', '~> 0.8')
  spec.add_development_dependency('database_cleaner', '~> 1.0')

  spec.add_dependency 'mongoid-multitenancy'
  spec.add_dependency 'sidekiq', '>= 2.11'
end
