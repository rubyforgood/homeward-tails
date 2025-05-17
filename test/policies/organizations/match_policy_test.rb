require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class Organizations::MatchPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  context "#create?" do
    setup do
      @policy = -> {
        Organizations::MatchPolicy.new(Match, person: @person, user: @person&.user)
      }
      @action = -> { @policy.call.apply(:create?) }
    end

    context "when user is nil" do
      setup do
        @person = nil
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is adopter" do
      setup do
        @person = create(:person, :adopter)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is fosterer" do
      setup do
        @person = create(:person, :fosterer)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is admin" do
      setup do
        @person = create(:person, :admin)
      end

      should "return true" do
        assert_equal true, @action.call
      end
    end

    context "when user is super admin" do
      setup do
        @person = create(:person, :super_admin)
      end

      should "return true" do
        assert_equal true, @action.call
      end
    end

    context "when user is deactivated staff" do
      setup do
        @person = create(:person, :admin, deactivated: true)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end
  end

  context "#destroy?" do
    setup do
      @match = create(:match, match_type: :adoption)
      @policy = -> {
        Organizations::MatchPolicy.new(@match, person: @person, user: @person&.user)
      }
      @action = -> { @policy.call.apply(:destroy?) }
    end

    context "when user is nil" do
      setup do
        @person = nil
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is adopter" do
      setup do
        @person = create(:person, :adopter)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is fosterer" do
      setup do
        @person = create(:person, :fosterer)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is admin" do
      setup do
        @person = create(:person, :admin)
      end

      context "when match belongs to a different organization" do
        setup do
          ActsAsTenant.with_tenant(create(:organization)) do
            @match = create(:match, match_type: :adoption)
          end
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when match belongs to user's organization" do
        should "return true" do
          assert_equal true, @action.call
        end
      end
    end

    context "when user is super admin" do
      setup do
        @person = create(:person, :super_admin)
      end

      should "return true" do
        assert_equal true, @action.call
      end
    end

    context "when user is deactivated staff" do
      setup do
        @person = create(:person, :admin, deactivated: true)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end
  end
end
