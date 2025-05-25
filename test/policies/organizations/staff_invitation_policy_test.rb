require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class Organizations::StaffInvitationPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  setup do
    @policy = -> {
      Organizations::StaffInvitationPolicy.new(
        User, person: @person, user: @person&.user
      )
    }
  end

  context "#new?" do
    setup do
      @action = -> { @policy.call.apply(:new?) }
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

      should "return false" do
        assert_equal false, @action.call
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
        @person = create(:person, :super_admin, deactivated: true)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end
  end
end
