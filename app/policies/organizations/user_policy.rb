class Organizations::UserPolicy < ApplicationPolicy
  pre_check :verify_organization!
  pre_check :verify_active_staff!

  def index?
    permission?(:manage_staff)
  end

  def update_activation?
    permission?(:activate_staff) && record.id != user.id
  end
end
