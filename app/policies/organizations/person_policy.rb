class Organizations::PersonPolicy < ApplicationPolicy
  pre_check :verify_record_organization!

  alias_rule :edit?, :update?, to: :manage?

  def index?
    permission?(:view_people)
  end

  def show?
    permission?(:view_people)
  end

  def manage?
    if record == person
      permission?(:edit_own_person_attributes)
    else
      permission?(:manage_people_attributes)
    end
  end
end
