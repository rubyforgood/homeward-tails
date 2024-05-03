require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  setup do
    @user = create(:staff)
    @organization = @user.organization
    @page_text = create(:page_text, :with_image, organization: @organization)
    Current.organization = @organization
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
end
