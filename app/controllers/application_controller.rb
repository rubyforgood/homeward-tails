class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  verify_authorized unless: :devise_controller?
  before_action :set_current_user
  around_action :switch_locale

  rescue_from ActionPolicy::Unauthorized do |ex|
    flash[:alert] = t("errors.authorization_error")

    redirect_back fallback_location: root_path
  end

  def set_current_user
    Current.user = current_user
  end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
