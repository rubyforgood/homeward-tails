# frozen_string_literal: true

require "test_helper"

class PetTest < ActiveSupport::TestCase
  context "associations" do
    should have_many(:adopter_applications).dependent(:destroy)
    should have_many(:matches).dependent(:destroy)
    should have_many_attached(:images)
    should have_many(:likes).dependent(:destroy)
  end

  context "validations" do
    should validate_presence_of(:name)
    should validate_presence_of(:birth_date)
    should validate_presence_of(:breed)
    should validate_presence_of(:sex)
    should validate_presence_of(:species)
    should validate_presence_of(:placement_type)
    should validate_presence_of(:description)
    should validate_length_of(:description).is_at_most(1000)
    should validate_presence_of(:weight_from)
    should validate_numericality_of(:weight_from).only_integer
    should validate_presence_of(:weight_to)
    should validate_numericality_of(:weight_to).only_integer
    should validate_presence_of(:weight_unit)
    should validate_inclusion_of(:weight_unit).in_array(["lb", "kg"])
    should define_enum_for(:species)
    should define_enum_for(:placement_type)

    context "sensible_placement_type" do
      context "with unfinished foster match" do
        setup do
          @foster_match = create(:foster, start_date: 1.day.ago, end_date: Date.today + 30.days)
        end

        should "allow Adoptable and Fosterable" do
          @foster_match.pet.placement_type = "Adoptable and Fosterable"
          assert @foster_match.pet.valid?
        end

        should "allow Fosterable" do
          @foster_match.pet.placement_type = "Fosterable"
          assert @foster_match.pet.valid?
        end

        should "not allow Adoptable" do
          @foster_match.pet.placement_type = "Adoptable"
          assert @foster_match.pet.invalid?
        end
      end

      context "no unfinished foster matches" do
        setup do
          @foster_match = create(:foster, start_date: 30.days.ago, end_date: 10.days.ago)
        end

        should "allow Adoptable and Fosterable" do
          @foster_match.pet.placement_type = "Adoptable and Fosterable"
          assert @foster_match.pet.valid?
        end

        should "allow Fosterable" do
          @foster_match.pet.placement_type = "Fosterable"
          assert @foster_match.pet.valid?
        end

        should "allow Adoptable" do
          @foster_match.pet.placement_type = "Adoptable"
          assert @foster_match.pet.valid?
        end
      end
    end
  end

  context "scopes" do
    context ".with_photo" do
      should "return pets that have a photo on their profile" do
        pet_with_image = create(:pet, :with_image)
        pet_without_image = create(:pet)

        assert Pet.with_photo.include?(pet_with_image)
        assert_not Pet.with_photo.include?(pet_without_image)
      end
    end

    context ".unique_species" do
      should "returns an array of unique species" do
        create(:pet, species: "Dog")
        create(:pet, species: "Cat")
        create(:pet, species: "Dog")

        unique_species = Pet.unique_species

        assert_equal ["Cat", "Dog"], unique_species.sort
        assert_equal 1, unique_species.count("Dog")
      end
    end
  end

  context "#has_adoption_pending?" do
    should "return true if there is an adopter application with 'adoption_pending' status" do
      pet = Pet.new
      adopter_application = pet.adopter_applications.new
      adopter_application.status = "adoption_pending"
      assert pet.has_adoption_pending?

      adopter_application.status = "awaiting_review"
      assert_not pet.has_adoption_pending?
    end
  end

  context "#is_adopted?" do
    should "return true if there is a match with 'adoption' match_type" do
      pet = create(:pet)
      match = create(:match, :adoption, pet:)
      assert pet.is_adopted?

      match.update(match_type: "foster")
      assert_not pet.is_adopted?
    end
  end

  context "#in_foster?" do
    should "return true if there is a match with 'foster' match_type" do
      pet = create(:pet)
      match = create(:foster, pet:, start_date: 1.month.ago, end_date: 1.day.from_now)
      assert pet.in_foster?

      match.update(match_type: "adoption")
      assert_not pet.in_foster?
    end
  end

  context "ransack_adopted" do
    setup do
      create(:pet)
      create(:pet)
      create(:pet, :adopted)
    end

    should "should return adopted pets" do
      adopted_pets = Pet.ransack_adopted("adopted")
      assert_equal 1, adopted_pets.count
    end

    should "should return unadopted pets" do
      unadopted_pets = Pet.ransack_adopted("unadopted")
      assert_equal 2, unadopted_pets.count
    end

    should "should return adopted pets via Pet.ransack" do
      adopted_pets = Pet.ransack({"ransack_adopted" => "adopted"})
      assert_equal 1, adopted_pets.result.count
    end

    should "should return unadopted pets via Pet.ransack" do
      unadopted_pets = Pet.ransack({"ransack_adopted" => "unadopted"})

      assert_equal Pet.ransack_adopted(false).to_sql, unadopted_pets.result.to_sql
      assert_equal 2, unadopted_pets.result.count
    end
  end
end
