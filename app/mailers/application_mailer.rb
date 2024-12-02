class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.config.from_email
  layout "mailer"

  before_action :set_app_root_url
  around_action :with_organization_path, if: -> { Current.organization }

  private

  def set_app_root_url
    @app_root_url = Rails.application.config.app_url
  end

  def with_organization_path
    default_url_options[:script_name] = "/#{Current.organization.slug}"
    yield
  ensure
    default_url_options[:script_name] = nil
  end
end
