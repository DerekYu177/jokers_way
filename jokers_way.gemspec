# frozen_string_literal: true

# lib = File.expand_path('lib', __dir__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require_relative 'lib/jokers_way/version'

Gem::Specification.new do |s|
  s.name          = 'jokers_way'
  s.version       = JokersWay::VERSION
  s.summary       = 'A game engine for the popular game 大怪路子.'
  s.description   = 'A game engine for the popular game 大怪路子.'
  s.authors       = ['Derek Yu']
  s.email         = ['derek-nis@hotmail.com']
  s.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git Gemfile])
    end
  end
  s.homepage      = 'https://github.com/DerekYu177/jokers_way'
  s.license       = 'MIT'
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 3.3.0'
  s.metadata['rubygems_mfa_required'] = 'true'
  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = s.homepage

  s.add_runtime_dependency 'activesupport', '~> 7.0.4'
  s.add_runtime_dependency 'pry', '~> 0.14.1'
  s.add_runtime_dependency 'pry-byebug', '~> 3.10.1'
end
