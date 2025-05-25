class Organizations::DefaultPetTaskPolicy < ApplicationPolicy
  pre_check :verify_record_organization!

  alias_rule :new?, :create?, :index?, to: :manage?

  def manage?
    permission?(:manage_default_pet_tasks)
  end
end
