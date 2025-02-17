class AdopterApplicationPolicy < ApplicationPolicy
  authorize :pet, optional: true
  pre_check :verify_pet_appliable!, only: %i[create?]

  relation_scope do |relation|
    relation.where(person_id: user.person) # Person.where(user_id: user.id).first)
  end

  def update?
    applicant? && permission?(:withdraw_adopter_applications)
  end

  def index?
    permission?(:view_adopter_applications)
  end

  def create?
    permission?(:create_adopter_applications)
  end

  private

  def applicant?
    # user.person_id == record.person.id
    user.person.id == record.person.id
  end

  def already_applied?
    user.person.adopter_applications.any? do |application|
      application.pet_id == pet.id
    end
  end

  def verify_pet_appliable!
    deny! if pet.application_paused
    deny! if already_applied?
  end
end
