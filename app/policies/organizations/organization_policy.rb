module Organizations
  class OrganizationPolicy < ApplicationPolicy
    def manage?
      permission?(:manage_organization)
    end
  end
end
