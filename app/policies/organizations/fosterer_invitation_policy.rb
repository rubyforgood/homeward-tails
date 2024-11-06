class Organizations::FostererInvitationPolicy < ApplicationPolicy
  pre_check :verify_organization!
  pre_check :verify_active_staff!

  def create?
    permission?(:invite_fosterers)
  end

  def update?
    permission?(:update_fosterers)
  end

  def edit?
    permission?(:update_fosterers)
  end
end
