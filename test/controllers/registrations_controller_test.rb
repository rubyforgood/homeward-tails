require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should assign adopter role when user is persisted" do
    registration_params = {user: attributes_for(:user)}

    post user_registration_url, params: registration_params

    persisted_user = User.find_by(email: registration_params[:user][:email])
    has_role = persisted_user.has_role?(:adopter, ActsAsTenant.current_tenant)

    assert_equal has_role, true
  end

  test "should get new with dashboard layout when signed in as staff" do
    user = create(:staff)
    organization = user.staff_account.organization
    sign_in user

    get edit_user_registration_url(script_name: "/#{organization.slug}")
    assert_select "nav.navbar-vertical", 1
  end

  test "should get new with application layout when signed in but not staff" do
    user = create(:user)
    organization = create(:organization)
    sign_in user

    get edit_user_registration_url(script_name: "/#{organization.slug}")
    assert_select "nav.navbar-vertical", 0
  end
end
