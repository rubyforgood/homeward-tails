module Organizations
  class GroupManagementPolicy < ApplicationPolicy
    authorize :group
    pre_check :verify_record_organization!

    def add_group?
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
