# Active Sort Order

<a href="https://badge.fury.io/rb/active_sort_order" target="_blank"><img height="21" style='border:0px;height:21px;' border='0' src="https://badge.fury.io/rb/active_sort_order.svg" alt="Gem Version"></a>
<a href='https://travis-ci.com/westonganger/active_sort_order' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://api.travis-ci.org/westonganger/active_sort_order.svg?branch=master' border='0' alt='Build Status' /></a>
<a href='https://rubygems.org/gems/active_sort_order' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://ruby-gem-downloads-badge.herokuapp.com/active_sort_order?label=rubygems&type=total&total_label=downloads&color=brightgreen' border='0' alt='RubyGems Downloads' /></a>

Dead simple, fully customizable sorting pattern for ActiveRecord.


# Installation

```ruby
gem 'active_sort_order'
```

Then add `include ActiveSortOrder` to your ApplicationRecord or models.

If you want to apply to all models You can create an initializer if the ApplicationRecord model doesnt exist.

```ruby
### Preferred
class ApplicationRecord < ActiveRecord::Base
  include ActiveSortOrder
end

### OR for individual models

class Post < ActiveRecord::Base
  include ActiveSortOrder
end

### OR for all models without an ApplicationRecord model

# config/initializers/active_sort_order.rb
ActiveSupport.on_load(:active_record) do
  ### Load for all ActiveRecord models
  include ActiveSortOrder
end
```

The models that have `ActiveSortOrder` applied have the following methods available to your models:

You will likely want to define a `base_sort_order` method to the to each model class:

```ruby
def self.base_sort_order
  "lower(#{table_name}.name) ASC, lower(#{table_name}.code) ASC" # for example
end
```

# Basic Usage

### Sorting

You now have access to the following sorting methods:

```ruby
### Applies the classes base_sort_order if defined
Post.all.sort_order

### Use custom base_sort_order
Post.all.sort_order(base_sort_order: "lower(number) DESC")

### Output combined sort order (if present) AND applies the classes base_sort_order
Post.all.sort_order(params[:sort], params[:direction]) 

### Output combined sort order (if present) AND applies a custom base_sort_order
Post.all.sort_order(params[:sort], params[:direction], base_sort_order: "lower(number) DESC")
```

In the above examples:

 - `params[:sort]` is the full sql column name, you can use table names as well if desired
 - `params[:direction]` is either "asc" or "desc", case doesnt matter, falls back to "ASC" if no match

# Key Models Provided & Additional Customizations

This gem is just ONE concern with ONE scope. I strongly encourage you to read the code for this library to understand how it works within your project so that you are capable of customizing the functionality later. You can always copy the code directly into your project for deeper project-specific customizations.

- [lib/active_sort_order/concerns/sort_order_concern.rb](./lib/active_sort_order/concerns/sort_order_concern.rb)

# Helper / View Examples

We do not provide built in helpers or view templates because this is a major restriction to applications. Instead we provide simple copy-and-pasteable starter templates

```ruby
### app/helpers/application_helper.rb

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

Then use it within you views like:

```
<th>
  <%= sort_link :name %>
</th>

<th>
  <%= sort_link "companies.name", "Company Name" %>
</th>
```

# Credits

Created & Maintained by [Weston Ganger](https://westonganger.com) - [@westonganger](https://github.com/westonganger)
