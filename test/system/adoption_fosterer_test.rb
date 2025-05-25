require "application_system_test_case"

class AdoptionFostererTest < ApplicationSystemTestCase
  setup do
    person = create(:person, :adopter)
    @pet = create(:pet)
    create(:adopter_application, pet: @pet, person: person)

    sign_in person.user
  end

  context "adoption applications" do
    should "should show list of user's adoption applications" do
      visit adopter_fosterer_dashboard_index_path
      click_on "Adoption Applications"
      assert_text @pet.name
    end

    should "should let user withdraw and then delete applications from their list" do
      visit adopter_fosterer_adopter_applications_path
      assert_text @pet.name
      assert_text "Under Review"
      accept_confirm do
        click_on "Withdraw Application"
      end
      assert_text "Withdrawn"
      accept_confirm do
        click_on "Delete"
      end
      assert_no_text @pet.name
    end
  end
end
