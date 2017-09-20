require 'rake/testtask'

task :default => :spec

Rake::TestTask.new(:spec) do |t|
  t.test_files = FileList['spec/**/*_spec.rb']
  t.warning = true
end

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/**/*_test.rb']
  t.warning = true
end
