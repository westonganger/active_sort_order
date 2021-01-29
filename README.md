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

# Usage

## Base Order

You will likely want to define a `base_sort_order` class method to each model. 

This will be utilized when not providing a `:base_sort_order` argument.

```ruby
def self.base_sort_order
  "lower(#{table_name}.name) ASC, lower(#{table_name}.code) ASC" # for example
end
```

## Sorting

This gem defines one scope on your models: `sort_order`

This method uses `reorder` so any previously defined `order` will be removed.

In the below examples:

 - `params[:sort]` is a String of the full SQL column name, feel free to use any SQL as required
 - `params[:direction]` is a String, if nil/blank string value provided it will fallback to "ASC"

```ruby
### Applies the classes base_sort_order (if defined)
Post.all.sort_order

### Use custom base_sort_order
Post.all.sort_order(base_sort_order: "lower(number) DESC")

### Output combined sort order (if present) AND applies the classes base_sort_order (if defined)
Post.all.sort_order(params[:sort], params[:direction]) 

### output combined sort order (if present) and applies a custom base_sort_order
post.all.sort_order(params[:sort], params[:direction], base_sort_order: "lower(number) desc, lower(code) asc")

### Skip the classes base_sort_order by providing false or nil
Post.all.sort_order(params[:sort], params[:direction], base_sort_order: false)
Post.all.sort_order(params[:sort], params[:direction], base_sort_order: nil)
```

## Additional Customizations

This gem is just ONE concern with ONE scope. I strongly encourage you to read the code for this library to understand how it works within your project so that you are capable of customizing the functionality later. You can always copy the code directly into your project for deeper project-specific customizations.

- [lib/active_sort_order/concerns/sort_order_concern.rb](./lib/active_sort_order/concerns/sort_order_concern.rb)

## Helper / View Examples

We do not provide built in helpers or view templates because this is a major restriction to applications. Instead we provide simple copy-and-pasteable starter templates

```ruby
### app/helpers/application_helper.rb

module ApplicationHelper

  def sort_link(column, title = nil, opts = {})
    column = column.to_s

    if title && title.is_a?(Hash)
      opts = title
      title = opts[:title]
    end

    title ||= column.titleize

    if opts[:disabled]
      return title
    else
      if params[:direction].present? && params[:sort].present?
        direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
      else
        direction = "asc"
      end

      return link_to(title, params.to_unsafe_h.merge(sort: column, direction: direction))
    end
  end

end
```

Then use the link helper within your views like:

```erb
<th>
  <%= sort_link :name %>
</th>

<th>
  <%= sort_link "companies.name", "Company Name" %>
</th>

<th>
  <%= sort_link "companies.name", "Company Name", disabled: !@sort_enabled %>
</th>
```

# Credits

Created & Maintained by [Weston Ganger](https://westonganger.com) - [@westonganger](https://github.com/westonganger)
