# encoding: utf-8
$: << File.expand_path('../lib', __FILE__)
require_relative 'lib/loc_counter/version'

Gem::Specification.new do |s|
  s.name        = 'loc_counter'
  s.version     = LOCCounter::VERSION
  s.authors     = ['Vsevolod Romashov']
  s.email       = ['7@7vn.ru']
  s.homepage    = 'https://github.com/7even/loc_counter'
  s.summary     = 'CLI LOC counter for a Ruby project'
  s.description = 'A simple line-of-code counter for Ruby projects'
  s.licenses    = ['MIT']

  s.files         = Dir['lib/**/*.rb']
  s.test_files    = Dir['spec/**/*.rb']
  s.executables   = Dir['bin/*'].map { |file| File.basename(file) }
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.2.0'

  s.add_runtime_dependency 'commander', '~> 4.4'
  s.add_runtime_dependency 'terminal-table', '~> 1.8'
  s.add_runtime_dependency 'activesupport', '~> 5.1'

  s.add_development_dependency 'rake', '~> 12.3'
  s.add_development_dependency 'pry', '~> 0.11'
  s.add_development_dependency 'awesome_print', '~> 1.8'
  s.add_development_dependency 'rspec', '~> 3.7'
end
