module Organizations
  class ActivationsPolicy < ApplicationPolicy
    pre_check :verify_organization!
    pre_check :verify_active_staff!

    def update?
      return false if record.id == user.id

      record_role = record.roles.first.name

      if %w[super_admin admin].include?(record_role)
        permission?(:activate_staff)
      else
        permission?(:activate_foster) && permission?(:activate_adopter)
      end
    end
  end
end
