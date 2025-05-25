class Organizations::CustomPagePolicy < ApplicationPolicy
  pre_check :verify_record_organization!

  def manage?
    permission?(:manage_custom_page)
  end
end
