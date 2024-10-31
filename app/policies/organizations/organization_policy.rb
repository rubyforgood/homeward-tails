module Organizations
  class OrganizationPolicy < ApplicationPolicy
    pre_check :verify_active_staff!

    def manage?
      permission?(:manage_organization)
    end

    private

    def organization
      record
    end
  end
end
