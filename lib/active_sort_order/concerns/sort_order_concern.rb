module ActiveSortOrder
  module SortOrderConcern
    extend ActiveSupport::Concern

    included do
      
      scope :sort_order, ->(sort_str = nil, sort_direction = nil, base_sort_order: "NONE"){
        if [String, Symbol, NilClass].none?{|x| sort_str.is_a?(x) }
          raise ArgumentError.new("Invalid first argument `sort_str`, expecting a a String or Symbol")
        end

        if sort_str.present?
          sort_str = sort_str.to_s

          if sort_direction.is_a?(Symbol)
            sort_direction = sort_direction.to_s.gsub('_', ' ')
          end

          if sort_direction.nil? || (sort_direction.is_a?(String) && sort_direction == "")
            sort_direction = "ASC"
          elsif !sort_direction.is_a?(String)
            raise ArgumentError.new("Invalid second argument `sort_direction` #{sort_direction}, expecting a a String or Symbol")
          else
            valid_directions = [
              "ASC",
              "DESC",
              "ASC NULLS FIRST",
              "ASC NULLS LAST",
              "DESC NULLS FIRST",
              "DESC NULLS LAST",
            ].freeze

            sanitized_sort_direction = sort_direction.split(' ').join(' ')

            if !valid_directions.include?(sanitized_sort_direction.upcase)
              raise ArgumentError.new("Invalid second argument `sort_direction` #{sort_direction}")
            end
          end

          sql_str = "#{sort_str} #{sanitized_sort_direction}"
        end

        if base_sort_order == "NONE" && self.klass.respond_to?(:base_sort_order)
          base_sort_order = self.klass.base_sort_order
        end

        if base_sort_order && !base_sort_order.is_a?(String)
          raise ArgumentError.new("Invalid :base_sort_order #{base_sort_order}, expecting a String")
        end

        if base_sort_order.present?
          if sql_str.present?
            sql_str << ", #{base_sort_order}"
          else
            sql_str = base_sort_order
          end
        end

        sanitized_str = sql_str.blank? ? nil : Arel.sql(sanitize_sql_for_order(sql_str))

        next self.reorder(sanitized_str)
      }

    end

  end
end
