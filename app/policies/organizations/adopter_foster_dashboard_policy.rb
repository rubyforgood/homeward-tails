class Organizations::AdopterFosterDashboardPolicy < ApplicationPolicy
  pre_check :verify_organization!

  def index?
    permission?(:view_adopter_foster_dashboard)
  end
end
