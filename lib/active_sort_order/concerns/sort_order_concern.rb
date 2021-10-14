module ActiveSortOrder
  module SortOrderConcern
    extend ActiveSupport::Concern

    included do
      
      scope :sort_order, ->(sort_col_sql = nil, sort_direction_sql = nil, base_sort_order: true){
        if !sort_col_sql.is_a?(Array)
          sort_col_sql = [sort_col_sql].compact
        end

        sort_col_sql.each_with_index do |x, i|
          if [String, Symbol].exclude?(x.class)
            raise ArgumentError.new("Invalid first argument `sort_col_sql`, expecting a String or Symbol or Array")
          else
            sort_col_sql[i] = x.to_s
          end
        end

        if sort_col_sql.present?
          ### SORT DIRECTION HANDLING
          if sort_direction_sql.is_a?(Symbol)
            sort_direction_sql = sort_direction_sql.to_s.gsub('_', ' ')
          end

          if sort_direction_sql.nil? || (sort_direction_sql.is_a?(String) && sort_direction_sql == "")
            sort_direction_sql = "ASC"
          elsif !sort_direction_sql.is_a?(String)
            raise ArgumentError.new("Invalid second argument `sort_direction_sql`, expecting a String or Symbol")
          else
            valid_directions = [
              "ASC",
              "DESC",
              "ASC NULLS FIRST",
              "ASC NULLS LAST",
              "DESC NULLS FIRST",
              "DESC NULLS LAST",
            ].freeze

            orig_direction_sql = sort_direction_sql

            ### REMOVE DUPLICATE BLANKS - Apparently this also removes "\n" and "\t"
            sort_direction_sql = orig_direction_sql.split(' ').join(' ')

            if !valid_directions.include?(sort_direction_sql.upcase)
              raise ArgumentError.new("Invalid second argument `sort_direction_sql`: #{orig_direction_sql}")
            end
          end

          sql_str = sort_col_sql.map{|x| "#{x} #{sort_direction_sql}" }.join(", ")
        end
        
        ### BASE SORT ORDER HANDLING
        if base_sort_order == true
          if self.respond_to?(:base_sort_order)
            base_sort_order = self.base_sort_order

            if [String, NilClass, FalseClass].exclude?(base_sort_order.class)
              raise ArgumentError.new("Invalid value returned from class method `base_sort_order`")
            end
          else
            base_sort_order = nil
          end
        elsif base_sort_order && !base_sort_order.is_a?(String)
          raise ArgumentError.new("Invalid argument provided for :base_sort_order")
        end

        if base_sort_order.present?
          if sql_str.present?
            sql_str << ", #{base_sort_order}"
          else
            sql_str = base_sort_order
          end
        end

        if sql_str.blank?
          next self.where(nil)
        else
          sanitized_str = Arel.sql(sanitize_sql_for_order(sql_str))

          next self.reorder(sanitized_str)
        end
      }

    end

  end
end
