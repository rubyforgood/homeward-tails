require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class Organizations::UserRolesPolicyTest < ActiveSupport::TestCase
  setup do
    @account = create(:staff_admin)
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
        assert_equal @action.call, false
      end
    end

    context "when user is adopter" do
      setup do
        @user = create(:adopter)
      end

      should "return false" do
        assert_equal @action.call, false
      end
    end

    context "when user is fosterer" do
      setup do
        @user = create(:fosterer)
      end

      should "return false" do
        assert_equal @action.call, false
      end
    end

    context "when user is staff" do
      setup do
        @user = create(:staff)
      end

      should "return false" do
        assert_equal @action.call, false
      end
    end

    context "when user is staff admin" do
      setup do
        @user = create(:staff_admin)
      end

      context "when account belongs to a different organization" do
        setup do
          ActsAsTenant.with_tenant(create(:organization)) do
            @account = create(:staff)
          end
        end

        should "return false" do
          assert_equal @action.call, false
        end
      end

      context "when account belongs to user's organization" do
        should "return true" do
          assert_equal @action.call, true
        end
      end

      context "when account is the user" do
        setup do
          @account = @user
        end

        should "return false" do
          assert_equal @action.call, false
        end
      end
    end
  end
end
