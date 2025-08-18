module Organizations
  class GroupManagementPolicy < ApplicationPolicy
    authorize :group
    pre_check :verify_record_organization!

    def create?
      permission_by_group
    end

    def update?
      return false if record.id == person&.id
      if group.is_a?(Group)
        return false if record.organization_id != group.organization_id
        @group = group.name.to_sym
      end
      permission_by_group
    end

    private

    def permission_by_group
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
  end
end
