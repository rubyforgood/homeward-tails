class Organizations::LikePolicy < ApplicationPolicy
  authorize :pet, optional: true
  pre_check :verify_pet_likable!, only: %i[create? destroy?]

  def index?
    permission?(:manage_likes)
  end

  def create?
    permission?(:manage_likes)
  end

  def destroy?
    permission?(:manage_likes)
  end

  private

  def verify_pet_likable!
    # TODO: revist this. as long as the user is signed in they
    # should be able to like a pet given we no longer scope users
    # to an organization
    true
    #  deny! if pet.organization_id != user.organization_id
  end

  def pet
    @pet || record.pet
  end
end
