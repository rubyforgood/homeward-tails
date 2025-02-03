module Organizations
  class OrganizationPolicy < Organizations::ApplicationPolicy
    pre_check :verify_active_staff!

    def manage?
      permission?(:manage_organization)
    end
  end
end
