require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should assign adopter role when user is persisted" do
    registration_params = {user: attributes_for(:user)}

    post user_registration_url, params: registration_params

    persisted_user = User.find_by(email: registration_params[:user][:email])
    has_role = persisted_user.has_role?(:adopter, ActsAsTenant.current_tenant)

    assert_equal true, has_role
  end

  test "should get new with dashboard layout when signed in as staff" do
    user = create(:admin)
    organization = Current.organization
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

  test "should redirect to adopter foster dashboard when updated" do
    user = create(:adopter_fosterer, password: "123456")
    sign_in user

    updated_params = {user: {first_name: "not the same name", current_password: "123456"}}

    put user_registration_url, params: updated_params

    assert_redirected_to adopter_fosterer_dashboard_index_url
  end

  test "should redirect to staff dashboard when updated" do
    user = create(:admin, password: "123456")
    organization = Current.organization
    sign_in user

    updated_params = {user: {first_name: "Sean", current_password: "123456"}}

    put user_registration_url(script_name: "/#{organization.slug}"), params: updated_params

    assert_redirected_to staff_dashboard_index_url
  end
end
