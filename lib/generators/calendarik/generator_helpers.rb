module Calendarik
  module GeneratorHelpers
    mattr_accessor :full_klass_name_for_event

    def model_file_name
      "app/models/#{Calendarik::GeneratorHelpers.full_klass_name_for_event.underscore}.rb"
    end

    def table_name_for_event_migration_file
      Calendarik::GeneratorHelpers.full_klass_name_for_event.demodulize.underscore.pluralize
    end

    def migration_class_name
      Calendarik::GeneratorHelpers.full_klass_name_for_event.gsub(/::/, '').pluralize
    end

    def next_migration_number
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def table_name
      Calendarik::GeneratorHelpers.full_klass_name_for_event.demodulize.underscore.pluralize
    end
  end
end
