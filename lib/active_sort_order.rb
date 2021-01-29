require "active_record"

require "active_sort_order/concerns/sort_order_concern"

module ActiveSortOrder 
  extend ActiveSupport::Concern

  included do
    include ActiveSortOrder::SortOrderConcern
  end
end
