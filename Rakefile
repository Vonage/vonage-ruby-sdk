require 'rake/testtask'
require 'coveralls/rake/task'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/**/*_test.rb']
  t.warning = true
end
Coveralls::RakeTask.new

task :test_with_coveralls => [:test, 'coveralls:push']
