module Organizations
  class ActivationsPolicy < ApplicationPolicy
    authorize :group
    pre_check :verify_organization!
    pre_check :verify_active_staff!

    def update?
      return false if record.id == user.person&.id
      return false if record.organization_id != (user.person&.organization_id || group.organization_id)

      case group.name
      when "admin", "super_admin"
        permission?(:activate_staff)
      when "adopter", "fosterer"
        permission?(:activate_foster) && permission?(:activate_adopter)
      end
    end
  end
end
