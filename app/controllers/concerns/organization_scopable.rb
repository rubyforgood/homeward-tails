module OrganizationScopable
  extend ActiveSupport::Concern

  included do
    set_current_tenant_through_filter
    before_action :set_tenant
    before_action :verify_person_in_org, unless: -> { is_a?(Users::SessionsController) && action_name == "destroy" }
    # Add current person context to policies
    authorize :person, through: -> { Current.person }
  end

  def set_tenant
    if Current.organization.blank?
      redirect_to root_path, alert: t("general.organization_not_found")
    else
      set_current_tenant(Current.organization)
    end
  end

  def set_current_person
    # This is scoped to the org via acts_as_tenant - Only a single record will be returned if present.
    # ActsAsTenant.current_tenant is set prior to this, however if a query is attempted while
    # Current.organization is present and current_tenant is not set, an error with be raised via the acts_as_tenant initializer.
    # Current.person is used for authorization via Action Policy, and permission lookups in authorizable.rb

    Current.person = current_user.people.first
  end

  def verify_person_in_org
    return unless current_user
    set_current_person
    return if Current.person.present?

    redirect_to new_person_path, notice: "Please create a profile for this organization."
  end

  def after_sign_in_path_for(resource_or_scope)
    if allowed_to?(
      :index?, with: Organizations::DashboardPolicy
    )
      staff_dashboard_index_path
    elsif allowed_to?(
      :index?, with: Organizations::AdopterFosterDashboardPolicy
    )
      adopter_fosterer_dashboard_index_path
    else
      root_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def new_person_after_sign_up_path
    if Current.organization.external_form_url.present?
      adopter_fosterer_external_form_index_path
    else
      adopter_fosterer_dashboard_index_path
    end
  end
end
