#$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
ENV["RAILS_ENV"] = "test"

require "active_sort_order"

begin
  require 'warning'

  Warning.ignore(
    %r{mail/parsers/address_lists_parser}, ### Hide mail gem warnings
  )
rescue LoadError
  # Do nothing
end

### Instantiates Rails
require File.expand_path("../dummy_app/config/environment.rb",  __FILE__)

require "rails/test_help"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end

Rails.backtrace_cleaner.remove_silencers!

require 'minitest/reporters'
Minitest::Reporters.use!(
  Minitest::Reporters::DefaultReporter.new,
  ENV,
  Minitest.backtrace_filter
)

require "minitest/autorun"

# Run any available migration
if ActiveRecord::VERSION::MAJOR == 6
  ActiveRecord::MigrationContext.new(File.expand_path("dummy_app/db/migrate/", __dir__), ActiveRecord::SchemaMigration).migrate
else
  ActiveRecord::MigrationContext.new(File.expand_path("dummy_app/db/migrate/", __dir__)).migrate
end

[Post].each do |klass|
  if klass.connection.adapter_name.downcase.include?("sqlite")
    ActiveRecord::Base.connection.execute("DELETE FROM #{klass.table_name};")
    ActiveRecord::Base.connection.execute("UPDATE `sqlite_sequence` SET `seq` = 0 WHERE `name` = '#{klass.table_name}';")
  else
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{klass.table_name}")
  end
end

DATA = {}.with_indifferent_access

DATA[:posts] = [
  Post.find_or_create_by!(a: 1, b: 3),
  Post.find_or_create_by!(a: 2, b: 2),
  Post.find_or_create_by!(a: 3, b: 2),
  Post.find_or_create_by!(a: 4, b: 1),
  Post.find_or_create_by!(a: 5, b: 1),
].shuffle
