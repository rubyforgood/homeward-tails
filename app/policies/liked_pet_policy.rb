class LikedPetPolicy < ApplicationPolicy
  authorize :pet, optional: true

  def index?
    permission?(:manage_liked_pets)
  end

  def create?
    permission?(:manage_liked_pets)
  end

  def destroy?
    permission?(:manage_liked_pets)
  end
end