module SortArchitect
  module SortOrderConcern
    extend ActiveSupport::Concern

    included do
      ### VALIDATES ACTIVE RECORD MODEL
      if (self < ActiveRecord::Base)
        if self.respond_to?(:default_sort_order)
          default_base_order = self.default_sort_order
        end

        scope :sort_order, ->(sort_param = nil, direction_param = nil, base_order: default_base_order){
          if sort_param.present?
            if direction_param.present?
              if ["ASC", "DESC"].include?(direction_param.to_s.upcase)
                direction = direction_param
              else
                raise ArgumentError.new("Incorrect direction argument passed to `sort_order` method")
              end
            else
              direction = "ASC"
            end

            str = "#{sort_param} #{direction}"

            if base_order.present?
              str << ", #{base_order}"
            end
          end

          str ||= base_order.presence

          if str.present?
            next self.reorder(sanitize_sql_for_order(str))
          end
        }
      end
    end

  end
end
