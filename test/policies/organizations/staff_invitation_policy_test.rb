require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class Organizations::StaffInvitationPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  setup do
    @organization = ActsAsTenant.current_tenant
    @policy = -> {
      Organizations::StaffInvitationPolicy.new(
        User, organization: @organization, user: @user
      )
    }
  end

  context "#new?" do
    setup do
      @action = -> { @policy.call.apply(:new?) }
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

    context "when user is active staff" do
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

      context "when created staff is for a different organization" do
        setup do
          @organization = create(:organization)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when staff account is deactivated" do
        setup do
          @user.deactivate
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when created staff is for the same organization" do
        should "return true" do
          assert_equal true, @action.call
        end
      end
    end
  end
end
