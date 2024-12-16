require "test_helper"

class Organizations::ActivationsPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  setup do
    @policy = -> { Organizations::ActivationsPolicy.new(@user_being_updated, user: @user) }
  end

  context "when resource being updated is admin" do
    context "#update?" do
      setup do
        @user_being_updated = create(:admin)
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

      context "when user is admin" do
        setup do
          @user = create(:admin)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when user is super admin" do
        setup do
          @user = create(:super_admin)
        end

        should "return true" do
          assert_equal true, @action.call
        end

        context "when staff is self" do
          setup do
            @user_being_updated = @user
          end

          should "return false" do
            assert_equal false, @action.call
          end
        end
      end
    end
  end

  context "when resource being updated is fosterer" do
    context "#update?" do
      setup do
        @user_being_updated = create(:fosterer)
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

      context "when user is admin" do
        setup do
          @user = create(:admin)
        end

        should "return true" do
          assert_equal true, @action.call
        end
      end

      context "when user is super admin" do
        setup do
          @user = create(:super_admin)
        end

        should "return true" do
          assert_equal true, @action.call
        end
      end
    end
  end

  context "when resource being updated is adopter" do
    context "#update?" do
      setup do
        @user_being_updated = create(:adopter)
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

      context "when user is admin" do
        setup do
          @user = create(:admin)
        end

        should "return true" do
          assert_equal true, @action.call
        end
      end

      context "when user is super admin" do
        setup do
          @user = create(:super_admin)
        end

        should "return true" do
          assert_equal true, @action.call
        end
      end
    end
  end
end
