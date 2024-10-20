module OrganizationScopable
  extend ActiveSupport::Concern

  included do
    set_current_tenant_through_filter
    before_action :set_tenant
  end

  def set_tenant
    if Current.organization.blank?
      redirect_to root_path, alert: t("general.organization_not_found")
    else
      set_current_tenant(Current.organization)
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    if allowed_to?(
      :index?, with: Organizations::DashboardPolicy,
      context: {organization: Current.organization}
    )
      staff_dashboard_index_path
    elsif allowed_to?(
      :index?, with: Organizations::AdopterFosterDashboardPolicy,
      context: {organization: Current.organization}
    )
      adopter_fosterer_dashboard_index_path
    else
      root_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
