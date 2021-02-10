require 'rake/testtask'
require 'yard'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/**/*_test.rb']
  t.warning = true
end

YARD::Rake::YardocTask.new