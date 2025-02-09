require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class Organizations::UserRolesPolicyTest < ActiveSupport::TestCase
  setup do
    @account = create(:super_admin)
    @policy = -> {
      Organizations::UserRolesPolicy.new(@account, user: @user)
    }
  end

  context "#change_role?" do
    setup do
      @action = -> { @policy.call.apply(:change_role?) }
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

      # TODO: Are these tests still valid?
      context "when account belongs to a different organization" do
        setup do
          ActsAsTenant.with_tenant(create(:organization)) do
            @account = create(:admin)
          end
        end

        should "return true" do
          # assert_equal false, @action.call
          assert_equal true, @action.call
        end
      end

      context "when account belongs to user's organization" do
        should "return true" do
          assert_equal true, @action.call
        end
      end

      context "when account is the user" do
        setup do
          @account = @user
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end
    end
  end
end
