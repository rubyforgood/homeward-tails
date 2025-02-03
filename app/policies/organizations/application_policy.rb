class Organizations::ApplicationPolicy < ApplicationPolicy
  pre_check :verify_tos_agreement!

  def verify_tos_agreement!
    deny!(:no_tos_accepted) unless user.tos_agreement?
  end
end
