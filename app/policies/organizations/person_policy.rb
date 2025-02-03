class Organizations::PersonPolicy < Organizations::ApplicationPolicy
  pre_check :verify_organization!
  pre_check :verify_active_staff!

  def index?
    permission?(:view_people)
  end
end
