class Organizations::AdopterFosterDashboardPolicy < ApplicationPolicy
  def index?
    permission?(:view_adopter_foster_dashboard)
  end
end
