module ActiveSortOrder
  module SortOrderConcern
    extend ActiveSupport::Concern

    included do
      scope :sort_order, ->(sort_param = nil, direction_param = nil, base_sort_order: nil){
        if sort_param.present?
          if direction_param.present? && direction_param.to_s.upcase == "DESC"
            direction = "DESC"
          else
            direction = "ASC"
          end

          str = "#{sort_param} #{direction}"

          base_sort_order ||= self.klass.base_sort_order
          
          if base_sort_order.present?
            str << ", #{base_sort_order}"
          end
        end

        str ||= (base_sort_order || self.klass.base_sort_order)

        if str.present?
          next self.reorder(sanitize_sql_for_order(str))
        end
      }

    end

  end
end
