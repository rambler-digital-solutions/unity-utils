# frozen_string_literal: true

require_relative 'lib/unity/version'

Gem::Specification.new do |spec|
  spec.name          = 'unity-utils'
  spec.version       = Unity::VERSION
  spec.authors       = ['Mikhail Georgievskiy']
  spec.email         = ['m.georgievskiy@rambler-co.ru']

  spec.summary       = 'Gem with useful utils for writing scripts on ruby'
  spec.homepage      = 'https://github.com/rambler-digital-solutions/unity-utils.git'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage

  spec.files         = Dir['lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 4.2'
  spec.add_dependency 'faraday', '>= 1.0'
  spec.add_dependency 'rspec-rails', '>= 5.0'
  spec.add_dependency 'ruby-progressbar', '>= 1.11.0'
  spec.add_dependency 'test-prof', '~> 1.0'
end
