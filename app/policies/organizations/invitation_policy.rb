class Organizations::InvitationPolicy < Organizations::ApplicationPolicy
  pre_check :verify_organization!
  pre_check :verify_active_staff!

  # This policy denies all requests.
  # The sub InvitationPolicies should be used to authz where necessary.
  def create?
    deny!
  end
end
