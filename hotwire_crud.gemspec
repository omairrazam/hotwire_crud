# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'hotwire_crud'
  spec.version       = '1.1.0'
  spec.summary       = 'crud generator with hotwire approach and static routes'
  spec.description   = 'Crud generator with static routes which lazy loads content using content routes'
  spec.authors       = ['Umair Azam']
  spec.email         = ['omairr.azam@gmail.com']
  spec.homepage      = 'https://github.com/omairrazam/hotwire_crud.git'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*', 'templates/**/*', '*.gemspec']
  spec.require_paths = ['lib']
  spec.required_ruby_version = '3.1.2'
  spec.add_runtime_dependency 'rails', '>= 6.0'
  # Add other dependencies if needed

  # Specify the custom generator file(s)
  spec.add_development_dependency 'railties'
  spec.add_development_dependency 'rubocop', '~> 1.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
