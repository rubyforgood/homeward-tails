class Organizations::LikePolicy < ApplicationPolicy
  pre_check :verify_record_organization!

  def index?
    permission?(:manage_likes)
  end

  def create?
    permission?(:manage_likes)
  end

  def destroy?
    permission?(:manage_likes)
  end
end
