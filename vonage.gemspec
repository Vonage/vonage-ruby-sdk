require File.expand_path('lib/vonage/version', File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name = 'vonage'
  s.version = Vonage::VERSION
  s.license = 'Apache-2.0'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Vonage']
  s.email = ['devrel@vonage.com']
  s.homepage = 'https://github.com/Vonage/vonage-ruby-sdk'
  s.description = 'Vonage Server SDK for Ruby'
  s.summary = 'This is the Ruby Server SDK for Vonage APIs. To use it you\'ll need a Vonage account. Sign up for free at https://www.vonage.com'
  s.files = Dir.glob('lib/**/*.rb') + %w(LICENSE.txt README.md vonage.gemspec)
  s.required_ruby_version = '>= 2.5.0'
  s.add_dependency('nexmo-jwt', '~> 0.1.2')
  s.add_dependency('zeitwerk', '~> 2', '>= 2.2')
  s.add_dependency('sorbet-runtime', '~> 0.5')
  s.require_path = 'lib'
  s.metadata = {
    'homepage' => 'https://github.com/Vonage/vonage-ruby-sdk',
    'source_code_uri' => 'https://github.com/Vonage/vonage-ruby-sdk',
    'bug_tracker_uri' => 'https://github.com/Vonage/vonage-ruby-sdk/issues',
    'changelog_uri' => 'https://github.com/Vonage/vonage-ruby-sdk/blob/master/CHANGES.md',
    'documentation_uri' => 'https://www.rubydoc.info/github/vonage/vonage-ruby-sdk'
  }
end
