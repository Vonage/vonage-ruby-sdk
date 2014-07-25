Gem::Specification.new do |s|
  s.name = 'nexmo'
  s.version = '2.0.0'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Tim Craft']
  s.email = ['mail@timcraft.com']
  s.homepage = 'http://github.com/timcraft/nexmo'
  s.description = 'A Ruby wrapper for the Nexmo API'
  s.summary = 'See description'
  s.files = Dir.glob('{lib,spec}/**/*') + %w(README.md nexmo.gemspec)
  s.add_development_dependency('rake', '>= 0.9.3')
  s.add_development_dependency('webmock', '~> 1.18.0')
  s.require_path = 'lib'
end
