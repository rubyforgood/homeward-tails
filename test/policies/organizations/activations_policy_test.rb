require "test_helper"

class Organizations::ActivationsPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  context "when resource being updated is staff" do
    context "#update?" do
      context "when group is admin" do
        setup do
          # record being updated
          @person = create(:person, :admin)

          @action = -> {
            policy = Organizations::ActivationsPolicy.new(@person,
              user: @user,
              group: "admin")
            policy.stubs(:verify_active_staff!).returns(true)
            policy.apply(:update?)
          }
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
            @user = create(:person, :adopter).user
          end

          should "return false" do
            assert_equal false, @action.call
          end
        end

        context "when user is fosterer" do
          setup do
            @user = create(:person, :fosterer).user
          end

          should "return false" do
            assert_equal false, @action.call
          end
        end

        context "when user is admin" do
          setup do
            @user = create(:person, :admin).user
          end

          should "return false" do
            assert_equal false, @action.call
          end
        end

        context "when user is super admin" do
          setup do
            @user = create(:person, :super_admin).user
          end

          should "return true" do
            assert_equal true, @action.call
          end

          context "when person is self" do
            setup do
              @user = @person.user
            end

            should "return false" do
              assert_equal false, @action.call
            end
          end
        end
      end
      context "when group is super_admin" do
        setup do
          @person = create(:person, :super_admin)

          @action = -> {
            policy = Organizations::ActivationsPolicy.new(@person,
              user: @user,
              group: "super_admin")
            policy.stubs(:verify_active_staff!).returns(true)
            policy.apply(:update?)
          }
        end
        context "when user is super admin" do
          setup do
            @user = create(:person, :super_admin).user
          end

          should "return true" do
            assert_equal true, @action.call
          end
        end
      end
    end
  end

  context "when resource being updated is fosterer" do
    context "#update?" do
      setup do
        @person = create(:person, :fosterer)
        @action = -> {
          policy = Organizations::ActivationsPolicy.new(@person,
            user: @user,
            group: "fosterer")
          policy.stubs(:verify_active_staff!).returns(true)
          policy.apply(:update?)
        }
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
          @user = create(:person, :adopter).user
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when user is fosterer" do
        setup do
          @user = create(:person, :fosterer).user
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when user is admin" do
        setup do
          @user = create(:person, :admin).user
        end

        should "return true" do
          assert_equal true, @action.call
        end
      end

      context "when user is super admin" do
        setup do
          @user = create(:person, :super_admin).user
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
        @person = create(:person, :adopter)
        @action = -> {
          policy = Organizations::ActivationsPolicy.new(@person,
            user: @user,
            group: "adopter")
          policy.stubs(:verify_active_staff!).returns(true)
          policy.apply(:update?)
        }
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
          @user = create(:person, :adopter).user
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when user is fosterer" do
        setup do
          @user = create(:person, :fosterer).user
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when user is admin" do
        setup do
          @user = create(:person, :admin).user
        end

        should "return true" do
          assert_equal true, @action.call
        end
      end

      context "when user is super admin" do
        setup do
          @user = create(:person, :super_admin).user
        end

        should "return true" do
          assert_equal true, @action.call
        end
      end
    end
  end
end
