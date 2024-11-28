require_relative "boot"

require "rails/all"
require_relative "../lib/middleware/organization_middleware"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BajaPetRescue
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # config.active_record.verify_foreign_keys_for_fixtures = false

    # BPR - send errors to routes to render custom error pages
    config.exceptions_app = routes

    #
    # Added to manage the tenants within the path
    config.middleware.use OrganizationMiddleware

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.assets.paths << Rails.root.join("app", "assets", "builds")

    # Exclude this because we do not need to load this directly to servers, this is used to build
    # application.css
    config.assets.excluded_paths << Rails.root.join("vendor", "assets", "stylesheets")
  end
end
