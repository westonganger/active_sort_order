# ActiveRecord Sort Architect (WIP)

<a href="https://badge.fury.io/rb/active_record_sort_architect" target="_blank"><img height="21" style='border:0px;height:21px;' border='0' src="https://badge.fury.io/rb/active_record_sort_architect.svg" alt="Gem Version"></a>
<a href='https://travis-ci.com/westonganger/active_record_sort_architect' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://api.travis-ci.org/westonganger/active_record_sort_architect.svg?branch=master' border='0' alt='Build Status' /></a>
<a href='https://rubygems.org/gems/active_record_sort_architect' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://ruby-gem-downloads-badge.herokuapp.com/active_record_sort_architect?label=rubygems&type=total&total_label=downloads&color=brightgreen' border='0' alt='RubyGems Downloads' /></a>

Dead simple, fully customizable sorting pattern for ActiveRecord.


# Installation

```ruby
gem 'active_record_sort_architect'
```

Then add `include SortArchitect` to your ApplicationRecord or models.

If you want to apply to all models You can create an initializer if the ApplicationRecord model doesnt exist.

```ruby
### Preferred
class ApplicationRecord < ActiveRecord::Base
  include SortArchitect
end

### OR for individual models

class Post < ActiveRecord::Base
  include SortArchitect
end

### OR for all models without an ApplicationRecord model

# config/initializers/active_record_sort_architect.rb
ActiveSupport.on_load(:active_record) do
  ### Load for all ActiveRecord models
  include SortArchitect
end
```

The models that have `SortArchitect` applied have the following methods available to your models:

```ruby
scope :default_order, ->(){ order(self.default_sort_order) }
```

You will need to define the following custom methods to each model:

```ruby
def self.default_sort_order
  "lower(#{self.table_name}.name) ASC"
end
```

# Basic Usage

### Sorting

You now have access to the following sorting methods:

```ruby
### Outputs default sort order
Post.sort_order 

### Output combined sort order based on params (if present) AND default sort order
Post.sort_order(params[:sort], params[:direction]) 
```

Heres an example

```ruby
### Using params provided sort column and direction appended with the default sort order
###
### params[:sort] is the full sql column name, encouraged to use table names as well
### params[:direction] is either "asc" or "desc"

posts = Post
  .all
  .order(Post.sort_order(params[:sort], params[:direction]))

### Using only the default sort order
posts = Post
  .all
  .order(Post.sort_order)
```

NOTE: Any models with order in the `default_scope` may cause issues with the sorting so be sure to use `.unscope(:order)` where applicable.

# Key Models Provided & Additional Customizations

A key aspect of this library is its simplicity and small API. For major functionality customizations we encourage you to first delete this gem and then copy this gems code directly into your repository.

I strongly encourage you to read the code for this library to understand how it works within your project so that you are capable of customizing the functionality later.

- [SortOrderConcern](./lib/active_record_sort_architect/concerns/sort_order_concern.rb)

# View Examples

We do not provide built in view templates because this is a major restriction to applications. Instead we provide simple copy-and-pasteable starter templates

Sort Helper:

```ruby
module ApplicationHelper

  def sort_link(column, title = nil, opts = {})
    if title && title.is_a?(Hash)
      opts = title
      title = opts[:title]
    end

    title ||= column.titleize

    if opts[:disabled]
      title
    else
      direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"

      link_to title, params.to_unsafe_h.merge(sort: column, direction: direction)
    end
  end

end
```

```slim
= sort_link :name

= sort_link "companies.name", "Company Name"
```

# Credits

Created & Maintained by [Weston Ganger](https://westonganger.com) - [@westonganger](https://github.com/westonganger)
