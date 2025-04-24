class Organizations::StaffInvitationPolicy < ApplicationPolicy
  pre_check :verify_organization!
  # pre_check :verify_active_staff!

  def create?
    permission?(:invite_staff)
  end
end
