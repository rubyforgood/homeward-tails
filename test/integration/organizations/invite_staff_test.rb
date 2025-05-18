require "test_helper"

class Organizations::InviteStaffTest < ActionDispatch::IntegrationTest
  setup do
    admin = create(:person, :super_admin).user
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
    post(
      user_invitation_path,
      params: @user_invitation_one_params
    )

    assert_response :redirect

    invited_person = Person.find_by(email: "john@example.com")

    assert invited_person.user.invited_to_sign_up?
    assert invited_person.active_in_group?(:super_admin)

    assert_equal 1, ActionMailer::Base.deliveries.count
  end

  test "staff admin can not invite existing staff in the organization" do
    _existing_user = create(:person, :super_admin, email: "john@example.com")

    post(
      user_invitation_path,
      params: @user_invitation_one_params
    )
    assert_response :redirect
    follow_redirect!
    assert_equal "User is already Staff in this organization", flash[:notice]
  end

  test "staff admin can invite existing non-staff user to the organization" do
    _existing_user = create(:user, email: "adopter@example.com")

    post(
      user_invitation_path,
      params: @user_invitation_two_params
    )

    assert_response :redirect
    invited_person = Person.find_by(email: "adopter@example.com")

    assert invited_person.active_in_group?(:super_admin)
  end
end
