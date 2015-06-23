## fork https://github.com/vinsol/fullcalendar-rails-engine

## This engine supports only Rails 4 apps.

### Installation

Add calendarik to your Gemfile:

``` 
gem 'calendarik', :git => 'https://github.com/briu/calendarik.git'
```

#### Bundle install your dependencies and run the installation generator:

```
bundle install
bundle exec rails g calendarik:event_model ModelName custom_field_str:string custom_field_int:integer
bundle exec rake db:migrate
```

## Usage
Now you can use calendar on path `/fetch_event/model_name/events`

By default event form use only event fields, you can add your custom fields to form with partial, located in `/shared/events/model_name.html.erb`

## Config

Custom config rules for fullcalendar plugin should be stored in `config/calendarik.yml`
