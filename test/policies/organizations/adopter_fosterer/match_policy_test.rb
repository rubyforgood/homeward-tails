require "test_helper"

class Organizations::AdopterFosterer::MatchPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  setup do
    @organization = ActsAsTenant.current_tenant
    @policy = -> {
      Organizations::AdopterFosterer::MatchPolicy.new(
        Match, user: @user, organization: @organization
      )
    }
  end

  context "relation_scope" do
    setup do
      @user = create(:user)
      user_person = @user.person
      @pet = create(:pet)
      @adopted_application = create(:adopter_application, person: @user.person, pet: @pet, status: :adoption_made)
      @match = create(:match, person: @user.person, pet: @pet, match_type: :adoption)

      @other_user = create(:user)
      @other_pet = create(:pet)
      create(:adopter_application, person: @other_user.person, pet: @other_pet, status: :adoption_made)
      @other_match = create(:match, person: @other_user.person, pet: @other_pet, match_type: :adoption)

      ActsAsTenant.with_tenant(create(:organization)) do
        # TODO: Can't have the same person in different organizations
        create(:match, person: user_person, match_type: :adoption)
      end
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
        setup { @user = nil }
        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when user is adopter" do
        setup do
          @user = create(:adopter)
        end

        should "return true" do
          assert_equal true, @action.call
        end
      end

      context "when user is staff" do
        setup { @user = create(:admin) }

        should "return false" do
          assert_equal false, @action.call
        end
      end
    end
  end
end
