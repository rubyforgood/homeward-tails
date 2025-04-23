require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  setup do
    @user = create(:admin)
    @organization = Current.organization
    @custom_page = create(:custom_page, :with_about_us_image, organization: @organization)
  end

  context "when logging in as a staff member" do
    should "direct to the organization's pets index view" do
      visit root_url
      click_on "Log In"

      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_on "Log in"

      assert current_path.include?(@organization.slug)
      assert has_current_path?(staff_dashboard_index_path)
    end
  end

  context "when logging in as a fosterer" do
    setup do
      @user = create(:fosterer)
      @organization = Current.organization
      @custom_page = create(:custom_page, :with_about_us_image, organization: @organization)
    end

    should "direct to the user's dashboard" do
      visit root_url
      click_on "Log In"

      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_on "Log in"

      assert has_current_path?(adopter_fosterer_dashboard_index_path)
    end
  end
end
