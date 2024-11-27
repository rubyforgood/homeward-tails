class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  verify_authorized unless: :devise_controller?
  before_action :set_current_user
  around_action :switch_locale

  KNOWN_ERRORS = [ActionPolicy::Unauthorized]
  rescue_from StandardError, with: :log_and_reraise
  rescue_from ActionPolicy::Unauthorized do |ex|
    flash[:alert] = t("errors.authorization_error")

    redirect_back_or_to root_path
  end

  def set_current_user
    Current.user = current_user
  end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def log_and_reraise(error)
    unless KNOWN_ERRORS.include?(error.class)
      Bugsnag.notify(error)
      error.instance_eval { def skip_bugsnag = true }
    end
    raise
  end
end
