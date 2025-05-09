module OrganizationScopable
  extend ActiveSupport::Concern

  included do
    set_current_tenant_through_filter
    before_action :set_tenant
    before_action :verify_and_set_current_person
  end

  def set_tenant
    if Current.organization.blank?
      redirect_to root_path, alert: t("general.organization_not_found")
    else
      set_current_tenant(Current.organization)
    end
  end

  def verify_and_set_current_person
    return unless current_user

    # This is scoped to the org via acts_as_tenant - Only a single record will be returned if present.
    # ActsAsTenant.current_tenant is set prior to this, however if a query is attempted while
    # Current.organization is present and current_tenant is not set, an error with be raise via the acts_as_tenant initializer.
    # Current.person is used for authorization via Action Policy, and permission lookups in authorizable.rb

    person = current_user.people.first

    if person
      Current.person = person
    else
      redirect_to new_person_path, alert: "Please create a profile for this organization."
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    if allowed_to?(
      :index?, with: Organizations::DashboardPolicy,
      context: {person: Current.person}
    )
      staff_dashboard_index_path
    elsif allowed_to?(
      :index?, with: Organizations::AdopterFosterDashboardPolicy,
      context: {person: Current.person}
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
