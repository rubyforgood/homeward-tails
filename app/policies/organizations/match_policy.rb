class Organizations::MatchPolicy < ApplicationPolicy
  pre_check :verify_organization!
  pre_check :verify_active_staff!

  alias_rule :new?, :create?, :index?, to: :manage?

  def manage?
    permission?(:manage_matches)
  end
end
