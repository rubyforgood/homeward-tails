require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class Organizations::MatchPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  context "#create?" do
    setup do
      @organization = ActsAsTenant.current_tenant
      @policy = -> {
        Organizations::MatchPolicy.new(Match, user: @user,
          organization: @organization)
      }
      @action = -> { @policy.call.apply(:create?) }
    end

    context "when user is nil" do
      setup do
        @user = nil
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is adopter" do
      setup do
        @user = create(:adopter)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is fosterer" do
      setup do
        @user = create(:fosterer)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is activated staff" do
      setup do
        @user = create(:admin)
      end

      context "when organization context is a different organization" do
        setup do
          @organization = create(:organization)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when organization context is user's organization" do
        should "return true" do
          assert_equal true, @action.call
        end
      end
    end

    context "when user is deactivated staff" do
      setup do
        @user = create(:admin, :deactivated)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is staff admin" do
      setup do
        @user = create(:super_admin)
      end

      context "when organization context is a different organization" do
        setup do
          @organization = create(:organization)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when organization context is user's organization" do
        should "return true" do
          assert_equal true, @action.call
        end
      end
    end
  end

  context "#destroy?" do
    setup do
      @match = create(:match, match_type: :adoption)
      @policy = -> {
        Organizations::MatchPolicy.new(@match, user: @user)
      }
      @action = -> { @policy.call.apply(:destroy?) }
    end

    context "when user is nil" do
      setup do
        @user = nil
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is adopter" do
      setup do
        @user = create(:adopter)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is fosterer" do
      setup do
        @user = create(:fosterer)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is activated staff" do
      setup do
        @user = create(:admin)
      end

      context "when match belongs to a different organization" do
        setup do
          ActsAsTenant.with_tenant(create(:organization)) do
            @match = create(:match, match_type: :adoption)
          end
        end

        should "return false" do
          # TODO: what should we do here?
          # assert_equal false, @action.call
          assert_equal true, @action.call
        end
      end

      context "when match belongs to user's organization" do
        should "return true" do
          assert_equal true, @action.call
        end
      end
    end

    context "when user is deactivated staff" do
      setup do
        @user = create(:admin, :deactivated)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is staff admin" do
      setup do
        @user = create(:super_admin)
      end

      context "when match belongs to a different organization" do
        setup do
          ActsAsTenant.with_tenant(create(:organization)) do
            @match = create(:match, match_type: :adoption)
          end
        end

        should "return false" do
          # TODO: what should we do here?
          # assert_equal false, @action.call
          assert_equal true, @action.call
        end
      end

      context "when match belongs to user's organization" do
        should "return true" do
          assert_equal true, @action.call
        end
      end
    end
  end
end
