module Organizations
  class ActivationsPolicy < ApplicationPolicy
    pre_check :verify_organization!
    pre_check :verify_active_staff!

    def update_activation?
      return false if record.id == user.id

      record_role = record.roles.first.name

      if record_role == "super_admin" || record_role == "admin"
        permission?(:activate_staff)
      else
        permission?(:activate_foster) && permission?(:activate_adopter)
      end
    end
  end
end
