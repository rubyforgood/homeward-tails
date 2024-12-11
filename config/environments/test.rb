require "active_support/core_ext/integer/time"
require_dependency "acts_as_tenant/test_tenant_middleware"

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Turn false under Spring and add config.action_view.cache_template_loading = true.
  config.cache_classes = true
  # While tests run files are not watched, reloading is not necessary.
  config.enable_reloading = false

  # Eager loading loads your whole application. When running a single test locally,
  # this probably isn't necessary. It's a good idea to do in a continuous integration
  # system, or in some way before deploying your code.
  # load SimpleCov gem if running $ COVERAGE=true rails test
  config.eager_load = ENV["CI"].present? || ENV["COVERAGE"].present?

  # Configure public file server for tests with cache-control for performance.
  config.public_file_server.headers = {"cache-control" => "public, max-age=3600"}

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Render exception templates for rescuable exceptions and raise for other exceptions.
  config.action_dispatch.show_exceptions = :rescuable

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  config.serve_static_assets = true

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Set host to be used by links generated in mailer templates.
  config.action_mailer.default_url_options = {host: "example.com"}
  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raises error for missing translations.
  config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Devise config
  config.action_mailer.default_url_options = {host: "localhost", port: 3000}

  config.from_email = "test@email.com"
  config.app_url = "http://localhost:3000/"

  # Handle ActsAsTenant.test_tenant properly in request specs
  config.middleware.use ActsAsTenant::TestTenantMiddleware

  # Default queue adapter is :async which sometimes causes tests to hang
  # This fixes hanging
  # https://github.com/rails/rails/issues/48468
  config.active_job.queue_adapter = :test
  # Raise error when a before_action's only/except options reference missing actions.
  config.action_controller.raise_on_missing_callback_actions = true
end
