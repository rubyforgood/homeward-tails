class Organizations::TaskPolicy < ApplicationPolicy
  authorize :pet, optional: true

  pre_check :verify_record_organization!
  pre_check :verify_pet!

  alias_rule :create?, :new?, :index?, to: :manage?

  def manage?
    permission?(:manage_tasks)
  end

  private

  def pet
    @pet || record.pet
  end

  def verify_pet!
    deny! unless allowed_to?(:manage?, pet, with: Organizations::PetPolicy)
  end
end
