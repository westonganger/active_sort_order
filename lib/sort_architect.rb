require "active_record"

require "sort_architect/concerns/sort_order_concern"

module SortArchitect 
  include SortArchitect::SortOrderConcern
end
