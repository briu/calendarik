class EventsController < ApplicationController
  before_filter :take_event_constant

  def new
    if params[:event_click_date].present?
      @event = @event_klass.new(start_time: params[:event_click_date], end_time: (params[:event_click_date].to_date + 5.hour))
    else
      @event = @event_klass.new(end_time: 1.hour.from_now)
    end
    render json: { form: render_to_string( partial: '/events/form') }
  end

  def create
    event_manager = Calendarik::EventSeriesManager::EventSeriesCreator.new(@event_klass, event_params)
    if event_manager.create_event
      render nothing: true
    else
      render text: "Произошла ошибка", status: 422
    end
  end

  def index
  end

  def get_events
    events = @event_klass.where("start_time >= ? and end_time <= ?", params['start'], params['end']).map do |event|
      { 
        id: event.id,
        title: event.title,
        description: event.description,
        start: event.start_time.iso8601,
        end: event.end_time.iso8601,
        freeDay: event.free_day,
        allDay: event.all_day,
        recurring: event.recurring? ? true : false
      }
    end
    render :text => events.to_json
  end

  def move
    event = @event_klass.find_by_id params[:id]
    if event.present?
      time_column_update = Calendarik::WorkWithTime::TimeColumnUpdater.new(event, params)
      time_column_update.process_columns([:start_time, :end_time])
    end
    render nothing: true
  end

  def resize
    event = @event_klass.find_by_id params[:id]
    if event.present?
      time_column_update = Calendarik::WorkWithTime::TimeColumnUpdater.new(event, params)
      time_column_update.process_columns(:end_time)
    end
    render nothing: true
  end

  def edit
    @event = @event_klass.find_by_id(params[:id])
    render json: { form: render_to_string(partial: 'edit_form') }
  end

  def update
    event = @event_klass.find_by_id(params[:id])
    events_updater = Calendarik::EventSeriesManager::EventSeriesUpdater.new(event, event_params)
    events_updater.update_process
    render nothing: true
  end

  def destroy
    event = @event_klass.find_by_id(params[:id])
    if params[:delete_all] == 'true'
      @event_klass.where("id in (?)", event.same_events.map(&:id)).destroy_all
    elsif params[:delete_all] == 'future'
      @event_klass.where("id in (?)", event.future_same_events.map(&:id)).destroy_all
    end
    event.destroy
    render nothing: true
  end

  private

  def event_params
    params.require(params[:event_type]).permit(@event_klass.columns.map(&:name) + [:period, :frequency, :update_format])
  end

  def take_event_constant
    @event_klass = Object.const_get(params[:event_type].camelize)
  end
end
