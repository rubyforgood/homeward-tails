class Organizations::UserRolesPolicy < ApplicationPolicy
  pre_check :verify_record_organization!

  def change_role?
    record.id != person.id && permission?(:change_user_roles)
  end
end
