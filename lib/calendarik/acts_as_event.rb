module Calendarik
  module ActsAsEvent

    extend ActiveSupport::Concern

    included do

      attr_accessor :period, :frequency, :update_format

      def validate_timings
        if (start_time <= end_time)
          errors.add_to_base("Начало события должно быть раньше его окончания!")
        end
      end

      def recurring?
        event_series_label_timestamp.present?
      end

      def same_events
        self.class.where("event_series_label_timestamp = ?", event_series_label_timestamp)
      end

      def future_same_events
        self.class.where("event_series_label_timestamp = ? and created_at > ?", event_series_label_timestamp, created_at)
      end
    end

    class_methods do

      def specific_event_columns
        [:start_time, :end_time, :all_day, :free_day]
      end

      def info_columns_without_time
        columns.map(&:name) - ["id", "created_at", "updated_at", "start_time", "end_time"]
      end

      def repeat_variants
        #перевести и юзать I18n
        { "Не повторять" => '', "Каждый день" => "days", "Каждую неделю" => "weeks", "Каждый месяц" => "months", "Каждый год" => "years" }
      end

      def is_free_day?(date=Date.today)
        where('date(start_time) = date(?) and free_day = ?', date, true).present?
      end
    end
  end
end
