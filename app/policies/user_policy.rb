class UserPolicy < ApplicationPolicy
  def manage?
    record == user
  end
end
