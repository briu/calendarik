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
        #increase datetime_keys for datetime column by parameters with DateTime change method
        model_obj.send(column.to_s + "=", model_obj.send(column).change(build_hash_with_datetime_values(column)))
      end

      def build_hash_with_datetime_values(column)
        result = {}
        datetime_keys.each do |key|
          result[key] = model_obj.send(column).send(key) + values_for_update[key.to_s + "_delta"].to_i
        end
        result
      end

      def datetime_keys
        [:year, :month, :day, :hour, :min, :sec]
      end
    end

  end
end
