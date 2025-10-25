module DashboardContextable
  extend ActiveSupport::Concern

  included do
    before_action :set_dashboard_context
    layout :dashboard_layout

    helper_method :dashboard_layout, :dashboard_redirect_path, :current_dashboard_context
  end

  private

  # Called on every request to ensure the session knows which dashboard
  # the person is currently viewing.
  def set_dashboard_context
    return unless Current.person

    session[:dashboard_context] ||= default_dashboard_context_for(Current.person)
  end

  def dashboard_layout
    session[:dashboard_context] || default_dashboard_context_for(Current.person) || "application"
  end

  def dashboard_redirect_path
    case current_dashboard_context
    when "dashboard"
      staff_dashboard_index_path
    when "adopter_foster_dashboard"
      adopter_fosterer_dashboard_index_path
    else
      root_path
    end
  end

  def current_dashboard_context
    session[:dashboard_context] || default_dashboard_context_for(Current.person)
  end

  def default_dashboard_context_for(person)
    return nil unless person

    if person.active_in_group?(:admin, :super_admin)
      "dashboard"
    elsif person.active_in_group?(:adopter, :fosterer)
      "adopter_foster_dashboard"
    end
  end
end
