module Calendarik
  module WorkWithTime
    class TimeColumnUpdater

      attr_reader :model_obj
      attr_accessor :values_for_update

      def initialize(model_obj, values)
        @model_obj = model_obj
        @values_for_update = values
      end

      def process_columns(columns)
        if columns.is_a? Array
          columns.each{ |column| change_column(column) }
        else
          change_column(columns)
        end
        model_obj.save
      end

      def change_column(column)
        raise ArgumentError, "column should be ActiveSupport::TimeWithZone" unless model_obj.send(column).is_a? ActiveSupport::TimeWithZone
        update_time_values(column)
      end

      def update_time_values(column)
        datetime_keys.each do |params_key, pluralized_val|
          model_obj.send(column.to_s + '=', 
                         model_obj.send(column) + values_for_update[params_key.to_s + "_delta"].to_i.send(pluralized_val))
        end
      end

      def datetime_keys
        { day: :days, hour: :hours, minute: :minutes, sec: :seconds }
      end
    end
  end
end
