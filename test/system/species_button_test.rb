require "application_system_test_case"

class SpeciesButtonsTest < ApplicationSystemTestCase
  # This tests conditional rendering of browse species buttons on adopter fosterer dashboard
  setup do
    @user = create(:adopter_fosterer)
    @organization = create(:organization)
    create(:pet, species: "Dog", organization: @organization)
    create(:pet, species: "Cat", organization: @organization)
    create(:pet, species: "Dog", organization: @organization)
    Current.organization = @organization

    sign_in @user
  end

  should "display buttons for unique species and no duplicates" do
    visit adopter_fosterer_dashboard_index_path

    assert_link "Browse Dogs", href: adoptable_pets_path(species: "dog")
    assert_link "Browse Cats", href: adoptable_pets_path(species: "cat")
    assert_selector "a", text: "Browse Dogs", count: 1
  end
end
