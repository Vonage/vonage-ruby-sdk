Gem::Specification.new do |s|
  s.name = 'nexmo'
  s.version = '0.1.0'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Tim Craft']
  s.email = ['mail@timcraft.com']
  s.homepage = 'http://github.com/timcraft/nexmo'
  s.description = 'A simple wrapper for the Nexmo API'
  s.summary = 'See description'
  s.files = Dir.glob('{lib,test}/**/*') + %w(README.txt nexmo.gemspec)
  s.add_dependency('json', ['~> 1.5.1'])
  s.require_path = 'lib'
end
