require "application_system_test_case"

class AdoptablePetsTest < ApplicationSystemTestCase
  setup do
    create(:pet, species: "Dog", breed: "Labrador")
    create(:pet, species: "Dog", breed: "Pitbull")
    create(:pet, species: "Cat", breed: "Sphinx")
    create(:pet, species: "Cat", breed: "Siamese")
  end

  # TODO:Selecting the species should trigger an `input` event, but it doesn't because of a bug in Cuprite.
  # Remove the `page.evaluate_script` lines below once the bug has been fixed.
  # See: https://github.com/rubycdp/cuprite/issues/223
  test "selecting species filters breed dropdown options" do
    visit adoptable_pets_path
    assert_select("Breed", selected: ["All"], options: ["All", "Labrador", "Pitbull", "Siamese", "Sphinx"])

    select("Dog", from: "Species")
    page.evaluate_script("Stimulus.controllers[0].update()")

    assert_select("Breed", options: ["All", "Labrador", "Pitbull"])

    select("Cat", from: "Species")
    page.evaluate_script("Stimulus.controllers[0].update()")

    assert_select("Breed", options: ["All", "Sphinx", "Siamese"])

    select("All", from: "Species")
    page.evaluate_script("Stimulus.controllers[0].update()")

    assert_select("Breed", selected: ["All"], options: ["All", "Labrador", "Pitbull", "Siamese", "Sphinx"])
  end
end
