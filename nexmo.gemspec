Gem::Specification.new do |s|
  s.name = 'nexmo'
  s.version = '1.0.0'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Tim Craft']
  s.email = ['mail@timcraft.com']
  s.homepage = 'http://github.com/timcraft/nexmo'
  s.description = 'A simple wrapper for the Nexmo API'
  s.summary = 'See description'
  s.files = Dir.glob('{lib,spec}/**/*') + %w(README.md nexmo.gemspec)
  s.add_development_dependency('rake', '>= 0.9.3')
  s.add_development_dependency('mocha', '~> 0.10.3')
  s.add_development_dependency('multi_json', '~> 1.3.6')
  s.require_path = 'lib'

  if RUBY_VERSION == '1.8.7'
    s.add_development_dependency('minitest', '>= 4.2.0')
    s.add_development_dependency('json', '>= 1.6.5')
  end
end
