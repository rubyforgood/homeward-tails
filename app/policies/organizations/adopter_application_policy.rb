class Organizations::AdopterApplicationPolicy < ApplicationPolicy
  pre_check :verify_record_organization!

  alias_rule :index?, :show?, to: :manage?

  def manage?
    permission?(:review_adopter_applications)
  end
end
