require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class Organizations::UserPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  setup do
    @staff = create(:admin)
    @policy = -> { Organizations::UserPolicy.new(@staff, user: @user) }
  end

  context "#index?" do
    setup do
      @action = -> { @policy.call.apply(:index?) }
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

    context "when user is staff" do
      setup do
        @user = create(:admin)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is staff admin" do
      setup do
        @user = create(:super_admin)
      end

      context "when user is deactivated" do
        setup do
          @user.deactivate
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      should "return true" do
        assert_equal true, @action.call
      end
    end
  end

  context "#update_activation?" do
    setup do
      @action = -> { @policy.call.apply(:update_activation?) }
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

    context "when user is staff" do
      setup do
        @user = create(:admin)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is staff admin" do
      setup do
        @user = create(:super_admin)
      end

      should "return true" do
        assert_equal true, @action.call
      end

      context "when staff is self" do
        setup do
          @staff = @user
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end
    end
  end
end
