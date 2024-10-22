source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"

gem "action_policy", "~> 0.7.1"
gem "acts_as_tenant"
gem "active_link_to"
gem "active_storage_validations"
gem "azure-storage-blob", "~> 2.0", require: false
gem "bootsnap", require: false
gem "bootstrap"
gem "bootstrap_form", "~> 5.4"
gem "city-state", "~> 1.1.0"
gem "dartsass-sprockets"
gem "dartsass-rails"
gem "devise"
gem "devise_invitable", "~> 2.0.9"
gem "dry-types", "~> 1.7"
gem "dry-initializer", "~> 3.1"
gem "figaro"
gem "gretel", "~> 5.0"
gem "importmap-rails"
gem "jbuilder"
gem "pagy"
gem "pg", "~> 1.5"
gem "phonelib"
gem "puma", "~> 6.4.3"
gem "rails-i18n"
gem "rails", "~> 7.2.1"
gem "ransack"
gem "requestjs-rails", "~> 0.0.12"
gem "rolify"
gem "rails-controller-testing"
gem "sprockets-rails"
gem "stimulus-rails"
gem "strong_migrations", "~> 2.0"
gem "traceroute"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "view_component", "~> 3.14"

group :development, :test, :staging do
  gem "faker"
end

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "pry", "~> 0.14.2"

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
