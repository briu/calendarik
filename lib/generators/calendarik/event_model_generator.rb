require "rails/generators"
require "generators/calendarik/generator_helpers"

module Calendarik
  class EventModelGenerator < Rails::Generators::Base
    include Calendarik::GeneratorHelpers
    desc "Create an event model"

    argument :klass,  type: :string, desc: "Your event model name"
    argument :additional_attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"

    source_root File.expand_path('../templates', __FILE__)

    def create_event_model_files
      Calendarik::GeneratorHelpers.full_klass_name_for_event = klass + "Event"
      template("event_model.rb.erb", model_file_name)
      template("create_event_model_migration.rb.erb", migration_file_name)
    end

    private

    def migration_file_name
      "db/migrate/#{next_migration_number}_create_#{table_name_for_event_migration_file}.rb"
    end
  end
end
