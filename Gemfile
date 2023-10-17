source "https://rubygems.org"

gemspec

gem "rake"
gem "minitest"
gem 'minitest-reporters'

if RUBY_VERSION.to_f >= 2.4
  gem 'warning'
end

def get_env(name)
  (ENV[name] && !ENV[name].empty?) ? ENV[name] : nil
end

gem 'rails', get_env("RAILS_VERSION")

db_gem = get_env("DB_GEM") || "sqlite3"
gem db_gem
