module Organizations
  class GroupManagementPolicy < ApplicationPolicy
    authorize :group
    pre_check :verify_record_organization!

    def create?
      case group
      when :adopter
        permission?(:activate_adopter)
      when :fosterer
        permission?(:activate_foster)
      when :admin, :super_admin
        permission?(:activate_staff)
      else
        false
      end
    end

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
