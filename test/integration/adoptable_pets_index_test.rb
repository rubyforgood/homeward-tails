require "test_helper"

class AdoptablePetsIndexTest < ActionDispatch::IntegrationTest
  test "unauthenticated user can access adoptable pets index" do
    skip("while new ui is implemented")
    # get "/adoptable_pets"
    # check_messages
    # assert_select "h1", "Up for adoption"
  end

  test "all unadopted pets show on the pet_index page" do
    skip("while new ui is implemented")
    # get "/adoptable_pets"
    # assert_select "img.card-img-top", {count: @pet_count}
  end

  test "pet name shows adoption pending if it has any applications with that status" do
    skip("while new ui is implemented")
    # get "/adoptable_pets"
    # assert_select "h3", "#{@pet.name} (Adoption Pending)"
  end
end
