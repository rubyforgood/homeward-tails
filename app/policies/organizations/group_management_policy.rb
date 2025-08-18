module Organizations
  class GroupManagementPolicy < ApplicationPolicy
    authorize :group
    pre_check :verify_record_organization!

    def create?
      # group == name
      permission_by_group
    end

    def update?
      # group == object
      return false if record.id == person&.id
      return false if record.organization_id != group.organization_id

      @group = group.name.to_sym
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
