require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class Organizations::NotePolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  setup do
    @organization = ActsAsTenant.current_tenant
    @policy = -> {
      Organizations::NotePolicy.new(Note, person: @person, user: @person&.user)
    }
  end

  context "#update?" do
    setup do
      @action = -> { @policy.call.apply(:update?) }
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

    context "when user is staff" do
      setup do
        @person = create(:person, :admin)
      end

      should "return true" do
        assert_equal true, @action.call
      end
    end
  end
end
