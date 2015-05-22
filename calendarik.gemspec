$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "calendarik/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "calendarik"
  s.version     = Calendarik::VERSION
  s.authors     = ["Igor Biryukov"]
  s.email       = ["balalaukin@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Calendarik."
  s.description = "TODO: Description of Calendarik."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency  "fullcalendar-rails"
  s.add_dependency  "jquery-ui-rails"

  s.add_development_dependency "sqlite3"
end
