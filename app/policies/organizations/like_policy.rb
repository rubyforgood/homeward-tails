class Organizations::LikePolicy < ApplicationPolicy
  authorize :pet, optional: true

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

  def pet
    @pet || record.pet
  end
end
