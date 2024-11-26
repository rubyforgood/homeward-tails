class Organizations::AdopterApplicationPolicy < ApplicationPolicy
  pre_check :verify_organization!
  pre_check :verify_active_staff!

  alias_rule :index?, :show?, to: :manage?

  def manage?
    permission?(:review_adopter_applications)
  end
end
