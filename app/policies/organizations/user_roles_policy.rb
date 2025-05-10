class Organizations::UserRolesPolicy < ApplicationPolicy
  pre_check :verify_record_organization!

  def change_role?
    permission?(:change_user_roles) && record.id != person.id
  end
end
