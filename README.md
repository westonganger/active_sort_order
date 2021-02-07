# Active Sort Order

<a href="https://badge.fury.io/rb/active_sort_order" target="_blank"><img height="21" style='border:0px;height:21px;' border='0' src="https://badge.fury.io/rb/active_sort_order.svg" alt="Gem Version"></a>
<a href='https://github.com/westonganger/active_sort_order/actions' target='_blank'><img src="https://github.com/westonganger/active_sort_order/workflows/Tests/badge.svg" style="max-width:100%;" height='21' style='border:0px;height:21px;' border='0' alt="CI Status"></a>
<a href='https://rubygems.org/gems/active_sort_order' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://ruby-gem-downloads-badge.herokuapp.com/active_sort_order?label=rubygems&type=total&total_label=downloads&color=brightgreen' border='0' alt='RubyGems Downloads' /></a>

The "easy-peasy" dynamic sorting pattern for ActiveRecord that your Rails apps deserve. Useful for Rails controllers with large data, pagination, etc.

Features:

- Full SQL compatibility
- Dead Simple. Just [one concern with one scope](#additional-customizations).

## Installation

```ruby
gem 'active_sort_order'
```

Then add `include ActiveSortOrder` to your ApplicationRecord or individual models.

```ruby
class ApplicationRecord < ActiveRecord::Base
  include ActiveSortOrder
end
```

## Dynamic Sorting

This gem defines one scope on your models: `sort_order`

This method uses ActiveRecord's `reorder` under the hood, so any previously defined `order` will be removed upon calling `sort_order`

In the below examples we are within a controller and are using the params as our variables:

```ruby
# app/controllers/posts_controller.rb

if params[:sort] == "number_str"
  sort_col_sql = "CAST(posts.number_str AS int)"
else
  sort_col_sql = params[:sort]
end

### Output combined sort order (if present) and secondary / base sort order
Post.all.sort_order(sort_col_sql, params[:direction], base_sort_order: "lower(number) ASC, lower(code) ASC")

### Output combined sort order (if present) AND applies the classes base_sort_order (if defined)
Post.all.sort_order(sort_col_sql, params[:direction]) 
```

##### Method Definition:

`sort_order(sort_col_sql = nil, sort_direction_sql = nil, base_sort_order: true)`

Options:

- `sort_col_sql` is a SQL String of the column name
  * Feel free to use any SQL manipulation on the column name
  * There is no built-in SQL string validation so be sure to handle your sanitization in your project before passing to this method. See [Safely Handling Input](#safely-handling-input)
  * If blank value provided it will skip the dynamic sort and just apply the `base_sort_order`
- `sort_direction_sql` is a String of the SQL ORDER BY direction
  * The SQL String is automatically validated within the few allowable SQL ORDER BY directions.
  * If nil or "blank string" provided it will fallback to "ASC"
- `base_sort_order` is a String of the SQL base ordering
  * If not provided or true it will use the classes `base_sort_order` method (if defined)
  * If nil or false is provided it will skip the classes `base_sort_order`

## Base Sort Order

To maintain consistency when sorting its always a good idea to have a secondary or base sort order for when duplicates of the main sort column are found or no sort is provided.

For this you can define a `base_sort_order` class method to your models. 

This will be utilized on the `sort_order` method when not providing a direct `:base_sort_order` argument.

```ruby
class Post < ActiveRecord::Base
  include ActiveSortOrder

  def self.base_sort_order
    "lower(#{table_name}.name) ASC, lower(#{table_name}.code) ASC" # for example
  end

end
```

The default behaviours of this are shown below.

```ruby
### Applies the classes base_sort_order (if defined)
Post.all.sort_order

### Override the classes base_sort_order
Post.all.sort_order(base_sort_order: "lower(number) DESC")
# OR
Post.all.sort_order(sort_col_sql, params[:direction], base_sort_order: "lower(number) DESC")

### Skip the classes base_sort_order by providing false, nil will still use classes base_sort_order
Post.all.sort_order(sort_col_sql, params[:direction], base_sort_order: false) 
```

## Safely Handling Input

When accepting params or any custom input for column names it is wise to safely map the field name/alias to the correct SQL string rather than directly sending in the params.

Here is an example on how to handle this within your controller:

```ruby
if params[:sort].present?
  case params[:sort]
  when "author_name"
    sort_col_sql = "authors.name"
  when "a_or_b"
    sort_col_sql = "COALESCE(posts.field_a, posts.field_b)"
  when "price"
    sort_col_sql = "CAST(REPLACE(posts.price, '$', ',', '') AS int)"
  else
    raise "Invalid Sort Column Given: #{params[:sort]}"
  end
end

Post.all.sort_order(sort_col_sql, params[:direction])
```

## Additional Customizations

This gem is just one concern with one scope. I encourage you to read the code for this library to understand how it works within your project so that you are capable of customizing the functionality later. You can always copy the code directly into your project for deeper project-specific customizations.

- [lib/active_sort_order/concerns/sort_order_concern.rb](./lib/active_sort_order/concerns/sort_order_concern.rb)

## Helper / View Examples

We do not provide built in helpers or view templates because this is a major restriction to applications. Instead we provide a simple copy-and-pasteable starter template for the sort link:

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

## Credits

Created & Maintained by [Weston Ganger](https://westonganger.com) - [@westonganger](https://github.com/westonganger)
