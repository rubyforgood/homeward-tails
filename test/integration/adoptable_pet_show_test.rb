require "test_helper"

class AdoptablePetShowTest < ActionDispatch::IntegrationTest
  setup do
    @available_pet = create(:pet)
    set_organization(@available_pet.organization)
    @pet_in_draft = create(:pet, published: false)
    @pet_pending_adoption = create(:pet, :adoption_pending)
    @adopted_pet = create(:pet, :adopted)
  end

  teardown do
    check_messages
    :after_teardown
  end

  context "unauthenticated user" do
    should "see an available pet" do
      get adoptable_pet_path(@available_pet)

      assert_response :success
      assert_select "input[type='submit']", value: "Apply to Adopt", count: 0
    end

    should "see a pet with a pending adoption" do
      get adoptable_pet_path(@pet_pending_adoption)

      assert_response :success
    end

    should "not see an unpublished pet" do
      get adoptable_pet_path(@pet_in_draft)

      assert_response :redirect
    end

    should "not see an adopted pet" do
      get adoptable_pet_path(@adopted_pet)

      assert_response :redirect
    end
  end

  context "staff" do
    setup do
      sign_in create(:staff_account).user
    end

    should "see an available pet" do
      get adoptable_pet_path(@available_pet)

      assert_response :success
    end

    should "see a pet with a pending adoption" do
      get adoptable_pet_path(@pet_pending_adoption)

      assert_response :success
      assert_select "input[type='submit']", value: "Apply to Adopt", count: 0
    end

    should "see an unpublished pet" do
      get adoptable_pet_path(@pet_in_draft)

      assert_response :success
    end

    should "see an adopted pet" do
      get adoptable_pet_path(@adopted_pet)

      assert_response :success
    end

    context "an adopter" do
      setup do
        adopter_user = create(:adopter_foster_account).user
        create(:adopter_foster_profile, adopter_foster_account: adopter_user.adopter_foster_account)

        sign_in adopter_user
      end

      should "see and apply to an available pet" do
        get adoptable_pet_path(@available_pet)

        assert_response :success
        assert_select "input[type='submit']", value: "Apply to Adopt"
      end

      should "see a pet with a pending adoption" do
        get adoptable_pet_path(@pet_pending_adoption)

        assert_response :success
      end

      should "not see an unpublished pet" do
        get adoptable_pet_path(@pet_in_draft)

        assert_response :redirect
      end

      should "not see an adopted pet" do
        get adoptable_pet_path(@adopted_pet)

        assert_response :redirect
      end

      should_eventually "adopter application sees application status" do
        # pet = create(:pet, :adoption_pending)
        # user = create(:adopter, :with_profile, organization: pet.organization)
        # create(:adopter_application, adopter_foster_account: user.adopter_foster_account, pet: pet, status: :awaiting_review)
        # sign_in user

        # get "/adoptable_pets/#{pet.id}"

        # check_messages
        # assert_select "h4.me-2", "Application Awaiting Review"
      end

      should_eventually "pet name shows adoption pending if it has any applications with that status" do
        # pet = create(:pet, :adoption_pending)

        # get "/adoptable_pets/#{pet.id}"

        # check_messages
        # assert_select "h1", "#{pet.name} (Adoption Pending)"
      end
    end
  end
end
