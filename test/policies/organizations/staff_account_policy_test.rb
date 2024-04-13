require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class Organizations::StaffAccountPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  setup do
    @staff = create(:staff_account)
    @policy = -> { Organizations::StaffAccountPolicy.new(@staff, user: @user) }
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

      context "when user's staff account is deactivated" do
        setup do
          @user.staff_account.deactivate
        end

        should "return false" do
          assert_equal @action.call, false
        end
      end

      should "return true" do
        assert_equal @action.call, true
      end
    end
  end

  context "#activate?" do
    setup do
      @action = -> { @policy.call.apply(:activate?) }
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

      should "return true" do
        assert_equal @action.call, true
      end

      context "when staff is self" do
        setup do
          @staff = @user.staff_account
        end

        should "return false" do
          assert_equal @action.call, false
        end
      end
    end
  end

  context "#deactivate?" do
    should "be an alias to :activate?" do
      assert_alias_rule @policy.call, :deactivate?, :activate?
    end
  end

  context "#update_activation?" do
    should "be an alias to :activate?" do
      assert_alias_rule @policy.call, :update_activation?, :activate?
    end
  end
end
