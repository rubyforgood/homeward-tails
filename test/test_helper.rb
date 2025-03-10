# Per SimpleCov documentation, start gem before application
if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start do
    add_group "Model", "app/models"
    add_group "Controller", "app/controllers"
    add_group "Mailer", "app/mailers"
  end
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/unit"
require "mocha/minitest"

Dir[Rails.root.join("test", "support", "**", "*.rb")].sort.each { |f| require f }

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  parallelize_teardown do
    if ENV["COVERAGE"]
      SimpleCov.result
    end
  end
  # Devise test helpers
  include Devise::Test::IntegrationHelpers

  def set_organization(organization)
    Rails.application.routes.default_url_options[:script_name] = if organization
      "/#{organization.slug}"
    else
      ""
    end

    # Need to set the organization in the Current context
    # for tests that don't execute the full request stack
    # where this would be set by the middleware.
    # E.g. form_submission_policy_test.rb
    if organization
      Current.organization = organization
    end
  end

  setup do |test|
    if test.is_a?(ActionDispatch::IntegrationTest)
      ActsAsTenant.test_tenant = create(:organization, slug: "test")
    else
      ActsAsTenant.current_tenant = create(:organization, slug: "test")
    end

    set_organization(ActsAsTenant.current_tenant)
  end

  def teardown
    ActsAsTenant.current_tenant = nil
    ActsAsTenant.test_tenant = nil
    Rails.application.routes.default_url_options[:script_name] = ""
  end

  def check_messages
    assert_not response.parsed_body.include?("translation_missing"), "Missing translations, ensure this text is included in en.yml"
  end

  def after_teardown
    super
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end

  #
  # Sets up shoulda matcher configuration
  # https://github.com/thoughtbot/shoulda-matchers
  #
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :minitest
      with.library :rails
    end
  end
end

class ActionDispatch::IntegrationTest
  parallelize_setup do |worker|
    ActiveStorage::Blob.service.root = "#{ActiveStorage::Blob.service.root}-#{worker}"
    if ENV["COVERAGE"]
      SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
    end
  end
end
