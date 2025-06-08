class Organizations::StaffPolicy < ApplicationPolicy
  def index?
    permission?(:manage_staff)
  end
end
