Gem::Specification.new do |s|
  s.name = 'nexmo'
  s.version = '0.4.0'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Tim Craft']
  s.email = ['mail@timcraft.com']
  s.homepage = 'http://github.com/timcraft/nexmo'
  s.description = 'A simple wrapper for the Nexmo API'
  s.summary = 'See description'
  s.files = Dir.glob('{lib,spec}/**/*') + %w(README.md nexmo.gemspec MIT-LICENSE)
  s.add_dependency('multi_json')
  s.add_development_dependency('mocha')
  s.require_path = 'lib'
end
