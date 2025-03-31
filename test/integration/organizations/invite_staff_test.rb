require "test_helper"

class Organizations::InviteStaffTest < ActionDispatch::IntegrationTest
  setup do
    admin = create(:super_admin)
    sign_in admin

    @user_invitation_one_params = {
      user: {
        first_name: "John",
        last_name: "Doe",
        email: "john@example.com",
        roles: "super_admin"
      }
    }

    @user_invitation_two_params = {
      user: {
        first_name: "John",
        last_name: "Doe",
        email: "adopter@example.com",
        roles: "super_admin"
      }
    }
  end

  test "staff admin can invite other staffs to the organization" do
    current_organization = Current.organization
    post(
      user_invitation_path,
      params: @user_invitation_one_params
    )

    assert_response :redirect

    invited_user = User.find_by(email: "john@example.com")

    assert invited_user.invited_to_sign_up?
    assert invited_user.has_role?(:super_admin, current_organization)
    assert_not invited_user.deactivated?

    assert_equal 1, ActionMailer::Base.deliveries.count
  end

  test "staff admin can not invite existing staff in the organization" do
    _existing_user = create(:super_admin, email: "john@example.com")

    post(
      user_invitation_path,
      params: @user_invitation_one_params
    )

    assert_response :unprocessable_entity
  end

  test "staff admin can invite existing non-staff user to the organization" do
    _existing_user = create(:user, email: "adopter@example.com")
    current_organization = Current.organization

    post(
      user_invitation_path,
      params: @user_invitation_two_params
    )

    assert_response :redirect
    invited_user = User.find_by(email: "adopter@example.com")

    assert invited_user.has_role?(:super_admin, current_organization)
    assert_not invited_user.deactivated?
  end
end
