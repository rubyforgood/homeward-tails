module Organizations
  class ActivationsPolicy < ApplicationPolicy
    authorize :group
    pre_check :verify_record_organization!

    def update?
      return false if record.id == person&.id
      return false if record.organization_id != group.organization_id

      if group.admin? || group.super_admin?
        permission?(:activate_staff)
      elsif group.adopter? || group.fosterer?
        permission?(:activate_foster) && permission?(:activate_adopter)
      else
        false
      end
    end
  end
end
