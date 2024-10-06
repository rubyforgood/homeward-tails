class Organizations::UserPolicy < ApplicationPolicy
  pre_check :verify_organization!
  pre_check :verify_active_staff!

  alias_rule :deactivate?, :update_activation?, to: :activate?

  def index?
    permission?(:manage_staff)
  end

  def activate?
    permission?(:activate_staff) && record.id != user.id
  end
end
