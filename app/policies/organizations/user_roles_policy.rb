class Organizations::UserRolesPolicy < Organizations::ApplicationPolicy
  pre_check :verify_organization!
  pre_check :verify_active_staff!
  def change_role?
    permission?(:change_user_roles) && record.id != user.id
  end
end
