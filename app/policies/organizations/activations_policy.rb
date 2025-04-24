module Organizations
  class ActivationsPolicy < ApplicationPolicy
    authorize :group
    pre_check :verify_organization!
    # pre_check :verify_active_staff!

    def update?
      return false if record.id == user.person.id

      case group
      when "admin", "super_admin"
        permission?(:activate_staff)
      when "adopter", "fosterer"
        permission?(:activate_foster) && permission?(:activate_adopter)
      end
    end
  end
end
