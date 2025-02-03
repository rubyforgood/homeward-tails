class Organizations::CustomPagePolicy < Organizations::ApplicationPolicy
  pre_check :verify_organization!
  pre_check :verify_active_staff!

  def manage?
    permission?(:manage_custom_page)
  end
end
