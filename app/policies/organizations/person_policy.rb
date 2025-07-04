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
    edit_name ||= false

    if record == person
      permission?(:edit_own_person_attributes)
    elsif edit_name
      edit_name?
    else
      permission?(:manage_people_attributes)
    end
  end

  def edit_name?
    permission?(:edit_names)
  end
end
