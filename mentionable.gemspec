# frozen_string_literal: true

require_relative 'lib/mentionable/version'

Gem::Specification.new do |spec|
  spec.name          = 'mentionable'
  spec.version       = Mentionable::VERSION
  spec.authors       = ['Masaki Komagata']
  spec.email         = ['komagata@gmail.com']

  spec.summary       = 'Discovery mentions from ActiveRecord column.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/komagata/mentionable'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord'
  spec.add_dependency 'railties'
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'test-unit-rails'
end
