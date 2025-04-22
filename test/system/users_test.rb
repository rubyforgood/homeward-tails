require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = create(:admin)
    @organization = Current.organization
    @custom_page = create(:custom_page, :with_about_us_image, organization: @organization, hero: "Where every paw finds a home")
  end

  test "user can log out" do
    visit root_url
    click_on "Log In"

    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_on "Log in"

    assert current_path.include?(@organization.slug)
    assert has_current_path?(staff_dashboard_index_path)

    using_wait_time(5) do
      find("#dropdownUser").hover
    end

    click_on "Sign Out"

    assert_text "Signed out successfully"
  end

  test "non-authenticated user attempts to log out" do
    visit root_url
    refute has_button?("Sign out")
    expected_path = "/" + @organization.slug + "/home"
    assert has_current_path?(expected_path)
    assert_text "Where every paw finds a home"
  end
end
