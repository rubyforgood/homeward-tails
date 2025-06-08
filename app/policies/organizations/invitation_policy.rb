class Organizations::InvitationPolicy < ApplicationPolicy
  # This policy denies all requests.
  # The sub InvitationPolicies should be used to authz where necessary.
  def create?
    deny!
  end
end
