require "test_helper"

class Organizations::InviteStaffTest < ActionDispatch::IntegrationTest
  setup do
    admin = create(:person, :super_admin).user
    sign_in admin

    @user_invitation_one_params = {
      user: {
        email: "john@example.com",
        roles: "super_admin"
      },
      person: {
        first_name: "John",
        last_name: "Doe"
      }
    }

    @user_invitation_two_params = {
      user: {
        email: "adopter@example.com",
        roles: "super_admin"
      },
      person: {
        first_name: "John",
        last_name: "Doe"
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
    assert_equal "John", invited_person.first_name
    assert_equal "Doe", invited_person.last_name

    assert_equal 1, ActionMailer::Base.deliveries.count
  end

  test "staff admin can not invite existing staff in the organization" do
    user = create(:user, email: "john@example.com")
    _existing_user = create(:person, :super_admin, user: user, email: "john@example.com")

    post(
      user_invitation_path,
      params: @user_invitation_one_params
    )
    assert_response :redirect
    follow_redirect!
    assert_equal "User is already Staff in this organization", flash[:notice]
  end

  test "staff admin can invite existing non-staff user to the organization" do
    user = create(:user, email: "adopter@example.com")
    person = create(:person, :adopter, user: user, email: "adopter@example.com")

    post(
      user_invitation_path,
      params: @user_invitation_two_params
    )

    assert_response :redirect
    assert person.reload.active_in_group?(:super_admin)
  end
end
