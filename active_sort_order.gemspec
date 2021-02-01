require_relative 'lib/active_sort_order/version'

Gem::Specification.new do |s|
  s.name          = "active_sort_order"
  s.version       = ActiveSortOrder::VERSION
  s.authors       = ["Weston Ganger"]
  s.email         = ["weston@westonganger.com"]

  s.summary       = "The \"easy-peasy\" dynamic sorting pattern for ActiveRecord that your Rails apps deserve."
  s.description   = s.summary
  s.homepage      = "https://github.com/westonganger/active_sort_order"
  s.license       = "MIT"

  s.metadata["source_code_uri"] = s.homepage
  s.metadata["changelog_uri"] = File.join(s.homepage, "blob/master/CHANGELOG.md")

  s.files = Dir.glob("{lib/**/*}") + %w{ LICENSE README.md Rakefile CHANGELOG.md }
  s.test_files  = Dir.glob("{test/**/*}")
  s.require_path = 'lib'

  s.add_runtime_dependency "activerecord", '>= 5'
end
