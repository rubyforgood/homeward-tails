source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# figaro to handle ENV variables for postgresql
gem "figaro"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.4.3"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# add bootstrap gem
gem "bootstrap"

# add bootstrap_form gem
gem "bootstrap_form", "~> 5.4"

# Devise Authentication
gem "devise"

gem "devise_invitable", "~> 2.0.9"

# Use Sass to process CSS
gem "dartsass-sprockets"
gem "dartsass-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Active storage validations
gem "active_storage_validations"

# Use Azure Blob Storage for Active Storage
gem "azure-storage-blob", "~> 2.0", require: false

# validate adopter phone numbers
gem "phonelib"

# a rake task that helps find dead routes and unused actions
gem "traceroute"

# facilitates multi-tenancy, allowing database records to be associated with organizations
gem "acts_as_tenant"

# needed for internationalization (translations)
gem "rails-i18n"

# Provides helper methods to easily add 'active' tag on links
gem "active_link_to"

# needed for pagination
gem "pagy"

# Adds location data for cities and states around the world
gem "city-state", "~> 1.1.0"

# Adds a simple way to fetch with Javascript
gem "requestjs-rails", "~> 0.0.12"

# Add ability to set user roles
gem "rolify"

# Add breadcrumb management
gem "gretel", "~> 5.0"

# Use ransack for searching and filtering records
gem "ransack"

gem "rails-controller-testing"

# Use Action Policy for authorization framework
gem "action_policy", "~> 0.7.1"

# Use ViewComponent for our presenter pattern framework
gem "view_component", "~> 3.18"

# Use dry-types for defining types
gem "dry-types", "~> 1.7"

# Use dry-initializer for defining params and options for instances
gem "dry-initializer", "~> 3.1"

# Catch unsafe migrations
gem "strong_migrations", "~> 2.0"

group :development, :test, :staging do
  gem "faker"
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "pry", "~> 0.14.2"

  # Add annotation to models to make it easier to navigate in the codebase
  # and the database structure
  gem "annotate"

  # Linting
  gem "standard"

  # Analysis for security vulnerabilities
  gem "brakeman"

  # Creating factory instantiations in tests
  gem "factory_bot_rails"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # view emails in browser in dev
  gem "letter_opener", group: :development

  # better errors and guard gems
  gem "better_errors", "~> 2.9", ">= 2.9.1"
  gem "guard", "~> 2.18"
  gem "guard-livereload", "~> 2.5", ">= 2.5.2", require: false
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "cuprite"

  # Uses configuration based on Evil Martian's blog post:
  # https://evilmartians.com/chronicles/system-of-a-test-setting-up-end-to-end-rails-testing
  gem "evil_systems", "~> 1.1"

  # Code coverage analysis [https://github.com/simplecov-ruby/simplecov]
  gem "simplecov", require: false

  # Adds really common matchers you can use in tests to add
  # test coverage easily
  gem "shoulda", "~> 4.0"
  gem "shoulda-matchers"

  # Adds ability to stub out methods in tests easier
  gem "mocha"
end
