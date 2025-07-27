require "test_helper"

class Organizations::AdopterFosterer::MatchPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  setup do
    @policy = -> {
      Organizations::AdopterFosterer::MatchPolicy.new(
        Match, person: @person, user: @person&.user, type: "adoption"
      )
    }
  end

  context "relation_scope" do
    setup do
      @person = create(:person, :adopter)
      @pet = create(:pet)
      create(:adopter_application, person: @person, pet: @pet, status: :adoption_made)
      @match = create(:match, person: @person, pet: @pet, match_type: :adoption)

      @other_person = create(:person, :adopter)
      @other_pet = create(:pet)
      create(:adopter_application, person: @other_person, pet: @other_pet, status: :adoption_made)
      create(:match, person: @other_person, pet: @other_pet, match_type: :adoption)
    end

    should "return only the user's adopted pets" do
      scoped = @policy.call.apply_scope(Match.all, type: :active_record_relation)

      assert_equal 1, scoped.count
      assert_includes scoped, @match
    end
  end

  context "rules" do
    context "#index?" do
      setup do
        @action = -> { @policy.call.apply(:index?) }
      end

      context "when user is nil" do
        setup { @person = nil }
        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when user is adopter" do
        setup do
          @person = create(:person, :adopter)
        end

        should "return true" do
          assert_equal true, @action.call
        end
      end

      context "when user is staff" do
        setup { @person = create(:person, :admin) }

        should "return false" do
          assert_equal false, @action.call
        end
        context "and adopter" do
          setup do
            @person.add_group(:adopter)
          end
          should "return true" do
            assert_equal true, @action.call
          end
        end
      end
    end
  end
end
