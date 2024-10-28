require "application_system_test_case"

class NewOrganizationTest < ApplicationSystemTestCase
  setup do
    set_organization(nil)
  end

  context "request an account" do
    should "direct to the new organization's form", js: true do
      visit root_url
      click_on "Request an account", match: :first

      fill_in "Organization name", with: "New organization"
      fill_in "Your name", with: "Doe Smith"
      fill_in "Organization phone number", with: "12345678"
      fill_in "Organization email", with: "organization@example.com"
      select 'France', from: "Country"
      select "Corsica", from: "Province/State"
      fill_in "City/Town", with: "Calvi"
      click_on "Submit"

      assert_text "Message sent!"
    end
  end
end

