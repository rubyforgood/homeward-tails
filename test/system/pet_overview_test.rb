require "application_system_test_case"

class PetOverviewTest < ApplicationSystemTestCase
  setup do
    user = create(:person, :admin).user
    @pet = create(:pet)
    @all_overview_columns = %w[Sex Breed Weight Placement_Type Application_Status Publish_Status].map { |word| word.tr("_", " ") }
    sign_in user
  end

  context "when viewing a pet that has no matches" do
    should "show all overview fields" do
      visit staff_pet_path(@pet)
      assert has_current_path?(staff_pet_path(@pet))

      @all_overview_columns.each do |column|
        assert_text(column)
      end
    end
  end

  context "when viewing a pet that has a foster match" do
    should "show all overview fields" do
      create(:foster, pet_id: @pet.id)

      visit staff_pet_path(@pet)
      assert has_current_path?(staff_pet_path(@pet))

      @all_overview_columns.each do |column|
        assert_text(column)
      end
    end
  end

  context "when viewing a pet that has an adopter match" do
    should "hide some overview fields" do
      create(:match, pet_id: @pet.id)

      visit staff_pet_path(@pet)
      assert has_current_path?(staff_pet_path(@pet))
      (@all_overview_columns - %w[Placement_Type Application_Status Publish_Status].map { |word| word.tr("_", " ") }).each do |column|
        assert_text(column)
      end
    end
  end
end
