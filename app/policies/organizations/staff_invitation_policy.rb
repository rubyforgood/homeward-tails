class Organizations::StaffInvitationPolicy < ApplicationPolicy
  def create?
    permission?(:invite_staff)
  end
end
