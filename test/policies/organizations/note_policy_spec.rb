require "rails_helper"

RSpec.describe Organizations::NotePolicy, type: :policy do
  include PetRescue::PolicyAssertions

  setup do
    @organization = ActsAsTenant.current_tenant
    @policy = -> {
      Organizations::NotePolicy.new(Note, user: @user,
        organization: @organization)
    }
  end

  context "#update?" do
    setup do
      @action = -> { @policy.call.apply(:update?) }
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

    context "when user is deactivated staff" do
      setup do
        @user = create(:admin, :deactivated)
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

      should "return true" do
        assert_equal true, @action.call
      end
    end
  end
end
