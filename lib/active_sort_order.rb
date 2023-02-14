require "active_sort_order/version"

require "active_support/lazy_load_hooks"

ActiveSupport.on_load(:active_record) do
  require "active_sort_order/concerns/sort_order_concern"

  module ActiveSortOrder
    extend ActiveSupport::Concern

    included do
      include ActiveSortOrder::SortOrderConcern
    end
  end
end
