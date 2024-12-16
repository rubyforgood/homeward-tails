class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.config.from_email
  layout "mailer"
  around_action :with_organization_path, if: -> { Current.organization }

  private

  def with_organization_path
    default_url_options[:script_name] = "/#{Current.organization.slug}"
    yield
  ensure
    default_url_options[:script_name] = nil
  end
end
