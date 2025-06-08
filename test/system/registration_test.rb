require "application_system_test_case"

class RegistrationTest < ApplicationSystemTestCase
  setup do
    @user = create(:person, :admin).user
    @organization = Current.organization
    @custom_page = create(:custom_page, :with_about_us_image, organization: @organization)

    visit root_url
    click_on "Log In"

    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_on "Log in"
    visit edit_user_registration_path
  end

  context "when uploading avatar" do
    should "return error for invalid file type/size" do
      attach_file("Attach picture", Rails.root + "test/fixtures/files/blank.pdf")
      fill_in "Current password", with: @user.password
      click_on "Update"
      assert_selector("div.invalid-feedback", text: "must be PNG or JPEG")
    end

    should "direct to staff dashboard path with valid upload" do
      attach_file("Attach picture", Rails.root + "test/fixtures/files/test.png")
      fill_in "Current password", with: @user.password
      click_on "Update"

      assert has_current_path?(staff_dashboard_index_path)
    end
  end
end
