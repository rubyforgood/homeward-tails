require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class Organizations::DashboardPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  setup do
    @organization = ActsAsTenant.current_tenant
    @policy = -> {
      Organizations::DashboardPolicy.new(
        person: @person,
        user: @person&.user
      )
    }
  end

  context "#index?" do
    setup do
      @action = -> { @policy.call.apply(:index?) }
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
end
