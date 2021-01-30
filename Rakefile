require File.expand_path(File.dirname(__FILE__) + '/lib/active_sort_order/version.rb')

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task default: [:test]

task :console do
  require 'active_sort_order'

  require_relative 'test/dummy_app/app/models/application_record.rb'
  require_relative 'test/dummy_app/app/models/post.rb'
  Dir.glob("test/dummy_app/app/models/*.rb").each do |f|
    require_relative(f)
  end

  require 'irb'
  binding.irb
end
