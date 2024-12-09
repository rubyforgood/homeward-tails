require "test_helper"
require "action_policy/test_helper"

module Organizations
  class AdoptablePetsControllerTest < ActionDispatch::IntegrationTest
    include ActionPolicy::TestHelper

    setup do
      @pet = create(:pet, species: "Dog")
    end

    context "#index" do

      should "assign only unadopted pets" do
        adopted_pet = create(:pet, :adopted, species: "Dog")

        get adoptable_pets_url(species: "dog")

        assert_response :success
        assert_equal 1, assigns[:pets].count
        assert assigns[:pets].pluck(:id).exclude?(adopted_pet.id)
      end

      should "render information on pets" do
        get adoptable_pets_url(species: "dog")

        assert_select(".card li:nth-of-type(1)", text: /#{@pet.name}\s+#{@pet.species}/)
        assert_select(".card li:nth-of-type(2)", text: /Age/)
        assert_select(".card li:nth-of-type(3)", text: "Breed: #{@pet.breed}")
        assert_select(".card li:nth-of-type(4)", text: "Sex: #{@pet.sex}")
        assert_select(".card li:nth-of-type(5)", text: "Weight range: #{@pet.weight_from}-#{@pet.weight_to} #{@pet.weight_unit}")
      end
    end

  end
end
