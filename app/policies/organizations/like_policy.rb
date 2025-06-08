class Organizations::LikePolicy < ApplicationPolicy
  pre_check :verify_record_organization!, only: %i[create? destroy?]

  def index?
    permission?(:manage_likes)
  end

  def create?
    permission?(:manage_likes)
  end

  def destroy?
    return false unless record.person_id == person.id
    permission?(:manage_likes)
  end
end
