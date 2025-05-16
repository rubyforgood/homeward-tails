require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class Organizations::UserRolesPolicyTest < ActiveSupport::TestCase
  setup do
    # record being acted on
    @record = create(:person, :super_admin)
    @policy = -> {
      Organizations::UserRolesPolicy.new(@record, person: @person, user: @person&.user)
    }
  end

  context "#change_role?" do
    setup do
      @action = -> { @policy.call.apply(:change_role?) }
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

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is staff admin" do
      setup do
        @person = create(:person, :super_admin)
      end

      context "when record belongs to a different organization" do
        setup do
          ActsAsTenant.with_tenant(create(:organization)) do
            @record = create(:person, :super_admin)
          end
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when account belongs to user's organization" do
        should "return true" do
          assert_equal true, @action.call
        end
      end

      context "when account is the user" do
        setup do
          @record = @person
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end
    end
  end
end
