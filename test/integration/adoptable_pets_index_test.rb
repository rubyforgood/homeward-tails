require "test_helper"

class AdoptablePetsIndexTest < ActionDispatch::IntegrationTest
  setup do
    @available_pet = create(:pet)
    @pet_in_draft = create(:pet, published: false)
    @pet_pending_adoption = create(:pet, :adoption_pending)
    @adopted_pet = create(:pet, :adopted)
  end

  teardown do
    check_messages
  end

  test "unauthenticated user can access adoptable pets index" do
    get adoptable_pets_path(species: "dog")

    assert_response :success
  end
end
