require 'rake/testtask'
require "bundler/gem_tasks"
require 'yard'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/**/*_test.rb']
  t.warning = true
end

YARD::Rake::YardocTask.new

desc "Build gem"
task :build_gem do
  `rake build`
end

desc "Publish gem"
task publish_gem: [:build_gem] do
  `gem push pkg/*.gem`
  Rake::Task[:empty_pkg].invoke
end

desc "Empty pkg directory"
task :empty_pkg do
  `rm -rf pkg/*`
end
