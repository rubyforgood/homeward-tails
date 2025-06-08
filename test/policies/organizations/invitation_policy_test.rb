require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class Organizations::InvitationPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  setup do
    @organization = ActsAsTenant.current_tenant
    @policy = -> {
      Organizations::InvitationPolicy.new(
        User, person: @person, user: @person&.user
      )
    }
  end

  context "#new?" do
    should "be an alias to :create?" do
      assert_alias_rule @policy.call, :new?, :create?
    end
  end

  context "#create?" do
    setup do
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

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is super admin" do
      setup do
        @person = create(:person, :super_admin)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end
  end
end
