class Organizations::DashboardPolicy < ApplicationPolicy
  def index?
    permission?(:view_organization_dashboard)
  end

  def pets_with_incomplete_tasks?
    permission?(:view_organization_dashboard)
  end

  def pets_with_overdue_tasks?
    permission?(:view_organization_dashboard)
  end
end
