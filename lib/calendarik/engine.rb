require "fullcalendar-rails"
require "jquery-ui-rails"
require "momentjs-rails"

module Calendarik
  class Engine < Rails::Engine
    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end
  end
end
