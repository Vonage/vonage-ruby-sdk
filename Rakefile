require "bundler"
Bundler.setup
Bundler::GemHelper.install_tasks
require 'rake'
require 'rake/testtask'

task :default => :spec

Rake::TestTask.new(:spec) do |t|
  t.test_files = FileList['spec/*_spec.rb']
  t.warning = true
end
