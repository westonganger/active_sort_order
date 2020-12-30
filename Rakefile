require File.expand_path(File.dirname(__FILE__) + '/lib/sort_architect/version.rb')

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task default: [:test]

task :console do
  require 'sort_architect'

  require 'test/dummy_app/app/models/post'

  require 'irb'
  binding.irb
end
