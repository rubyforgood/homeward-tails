require "test_helper"

class AdoptablePetShowTest < ActionDispatch::IntegrationTest
  setup do
    @pet_id = pets(:one).id
    @adopted_pet_id = pets(:adopted_pet).id
  end

  test "unauthenticated users see create account prompt and link" do
    get "/adoptable_pets/#{@pet_id}"
    assert_response :success
    assert_select "h4", "Create an account to apply for this pet"
    assert_select "a", "Create Account"
  end

  test "adopter without a profile sees complete my profile prompt and link" do
    sign_in users(:adopter_without_profile)
    get "/adoptable_pets/#{@pet_id}"
    assert_response :success
    assert_select "h4", "Complete your profile to apply for this pet"
    assert_select "a", "Complete my profile"
  end

  test "adopter with a profile sees love this pooch question and apply button" do
    sign_in users(:adopter_with_profile)
    get "/adoptable_pets/#{@pet_id}"
    assert_response :success
    assert_select "h4", "In love with this pooch?"
    assert_select "form" do
      assert_select "button", "Apply to Adopt"
    end
  end

  test "staff do not see an adopt button only log out button" do
    sign_in users(:verified_staff_one)
    get "/adoptable_pets/#{@pet_id}"
    assert_response :success
    assert_select "form" do
      assert_select "button", "Log Out"
    end
    assert_select "form", count: 1
  end

  test "if pet status is paused and reason is opening soon this is displayed" do
    sign_in users(:verified_staff_one)

    put "/pets/#{@pet_id}",
      params: {pet:
      {
        organization_id: organizations(:one).id.to_s,
        name: "TestPet",
        age: "7",
        sex: "Female",
        breed: "mix",
        size: "Medium (22-57 lb)",
        description: "A lovely little pooch this one.",
        append_images: [""],
        application_paused: true,
        pause_reason: "opening_soon"
      }}

    logout
    sign_in users(:adopter_with_profile)
    get "/adoptable_pets/#{@pet_id}"
    assert_select "h3", "Applications Opening Soon"
  end

  test "if pet status is paused and reason is paused until further notice this is displayed" do
    sign_in users(:verified_staff_one)

    put "/pets/#{@pet_id}",
      params: {pet:
        {
          organization_id: organizations(:one).id.to_s,
          name: "TestPet",
          age: "7",
          sex: "Female",
          breed: "mix",
          size: "Medium (22-57 lb)",
          description: "A lovely little pooch this one.",
          append_images: [""],
          application_paused: true,
          pause_reason: "paused_until_further_notice"
        }}

    logout
    sign_in users(:adopter_with_profile)
    get "/adoptable_pets/#{@pet_id}"
    assert_select "h3", "Applications Paused Until Further Notice"
  end

  test "pet name shows adoption pending if it has any applications with that status" do
    @pet_id = pets(:pending_adoption_one).id
    get "/adoptable_pets/#{@pet_id}"
    assert_select "h1", "#{pets(:pending_adoption_one).name} (Adoption Pending)"
  end

  test "an adopted pet can't be shown as an adoptable pet" do
    get "/adoptable_pets/#{@adopted_pet_id}"
    assert_response :redirect
    follow_redirect!
    assert_equal "You can only view pets that need adoption.", flash[:alert]
  end
end
