require File.expand_path('lib/nexmo/version', File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name = 'nexmo'
  s.version = Nexmo::VERSION
  s.license = 'MIT'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Nexmo']
  s.email = ['devrel@nexmo.com']
  s.homepage = 'https://github.com/Nexmo/nexmo-ruby'
  s.description = 'Nexmo Client Library for Ruby'
  s.summary = 'This is the Ruby client library for Nexmo\'s API. To use it you\'ll need a Nexmo account. Sign up for free at https://www.nexmo.com'
  s.files = Dir.glob('lib/**/*.rb') + %w(LICENSE.txt README.md nexmo.gemspec)
  s.required_ruby_version = '>= 2.5.0'
  s.add_dependency('jwt', '~> 2')
  s.add_dependency('zeitwerk', '~> 2', '>= 2.2')
  s.require_path = 'lib'
  s.metadata = {
    'homepage' => 'https://github.com/Nexmo/nexmo-ruby',
    'source_code_uri' => 'https://github.com/Nexmo/nexmo-ruby',
    'bug_tracker_uri' => 'https://github.com/Nexmo/nexmo-ruby/issues',
    'changelog_uri' => 'https://github.com/Nexmo/nexmo-ruby/blob/master/CHANGES.md',
    'documentation_uri' => 'https://www.rubydoc.info/github/nexmo/nexmo-ruby'
  }
end
