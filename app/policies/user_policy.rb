class UserPolicy < ApplicationPolicy
  skip_pre_check :verify_tos_agreement!

  def manage?
    record == user
  end
end
