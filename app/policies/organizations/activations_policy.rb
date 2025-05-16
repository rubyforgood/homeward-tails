module Organizations
  class ActivationsPolicy < ApplicationPolicy
    authorize :group
    pre_check :verify_record_organization!

    def update?
      return false if record.id == person&.id
      return false if record.organization_id != group.organization_id

      case group.name
      when "admin", "super_admin"
        permission?(:activate_staff)
      when "adopter", "fosterer"
        permission?(:activate_foster) && permission?(:activate_adopter)
      end
    end
  end
end
