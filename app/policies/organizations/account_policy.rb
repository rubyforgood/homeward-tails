class Organizations::AccountPolicy < ApplicationPolicy
  pre_check :verify_record_organization!

  def show?
    deny! unless record == person
    permission?(:edit_own_person_attributes)
  end
end
