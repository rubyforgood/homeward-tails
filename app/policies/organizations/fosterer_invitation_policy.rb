class Organizations::FostererInvitationPolicy < ApplicationPolicy
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
