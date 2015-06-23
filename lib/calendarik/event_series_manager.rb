module Calendarik
  module EventSeriesManager

    class EventBase
      def take_event_info_without_time_columns(event, event_params)
        res = {}
        event.class.info_columns_without_time.each do |a|
          res[a] = event.send(a)
        end
        res
      end
    end

    class EventSeriesCreator < EventBase

      attr_reader :event_klass, :event, :event_params, :frequency, :period

      def initialize(event_klass, event_params)
        @event_klass   = event_klass
        @event_params = event_params
        @event_params[:event_series_label_timestamp] = DateTime.now.to_i
        @frequency = event_params.delete(:frequency)
        @period    = event_params.delete(:period)
      end

      def create_event
        if period.present?
          create_event_series
        else
          create_single_event
        end
      end

      def create_event_series
        success = true
        @event = create_single_event
        current_start_time, current_finish_time = event.start_time, event.end_time
        time_diff = current_finish_time - current_start_time

        while frequency.to_i.send(period).from_now(current_start_time) <= series_end_time
          current_start_time = frequency.to_i.send(period).from_now(current_start_time)
          current_finish_time = current_start_time + time_diff
          event = event_klass.new(event_params_without_time_columns)
          event.start_time, event.end_time = current_start_time, current_finish_time
          success = false unless event.save
        end
        success
      end

      def create_single_event
        event_klass.create(event_params)
      end

      def event_params_without_time_columns
        @columns_info_without_time_cols ||= take_event_info_without_time_columns(event, event_params)
      end

      private

      def series_end_time
        @series_end_time ||= 6.month.from_now
      end
    end

    class EventSeriesUpdater < EventBase

      attr_reader :event, :update_params, :format

      def initialize(event_for_update, update_params)
        @event = event_for_update
        @update_params = update_params
        @format = update_params[:update_format].presence || 'simple'
      end

      def update_process
        update_single_event
        update_event_series if ['same_events', 'future_same_events'].include? format
      end

      def update_single_event
        event.attributes = update_params
        event.save
      end

      def update_event_series
        attributes_for_update = take_event_info_without_time_columns(event, update_params)
        event.class.where("id in (?)", events_ids_for_update).update_all(attributes_for_update)
      end

      def events_ids_for_update
        event.send(format).map(&:id)
      end
    end
  end
end
