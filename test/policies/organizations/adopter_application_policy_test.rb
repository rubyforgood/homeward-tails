require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class Organizations::AdopterApplicationPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  context "context only action" do
    setup do
      @policy = -> {
        Organizations::AdopterApplicationPolicy.new(
          AdopterApplication, person: @person, user: @person&.user
        )
      }
    end

    context "#manage?" do
      setup do
        @action = -> { @policy.call.apply(:manage?) }
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

    context "#index?" do
      should "be an alias to :manage?" do
        assert_alias_rule @policy.call, :index?, :manage?
      end
    end
  end

  context "existing record action" do
    setup do
      @person = create(:person, :adopter)
      @adopter_application = create(:adopter_application, person: @person)
      @policy = -> {
        Organizations::AdopterApplicationPolicy.new(
          @adopter_application, person: @person, user: @person&.user
        )
      }
    end

    context "#manage?" do
      setup do
        @action = -> { @policy.call.apply(:manage?) }
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

    context "#edit?" do
      should "be an alias to :manage?" do
        assert_alias_rule @policy.call, :edit?, :manage?
      end
    end

    context "#update?" do
      should "be an alias to :manage?" do
        assert_alias_rule @policy.call, :update?, :manage?
      end
    end
  end
end
