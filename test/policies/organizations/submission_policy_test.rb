require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class Organizations::SubmissionPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  context "context only action" do
    setup do
      @organization = ActsAsTenant.current_tenant
      @policy = -> {
        Organizations::SubmissionPolicy.new(
          CustomForm::Submission, organization: @organization, user: @user
        )
      }
    end

    context "#manage?" do
      setup do
        @action = -> { @policy.call.apply(:manage?) }
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

      context "when user is activated staff" do
        setup do
          @user = create(:staff)
        end

        context "when organization context is a different organization" do
          setup do
            @organization = create(:organization)
          end

          should "return false" do
            assert_equal false, @action.call
          end
        end

        context "when organization context is user's organization" do
          should "return true" do
            assert_equal true, @action.call
          end
        end
      end

      context "when user is deactivated staff" do
        setup do
          @user = create(:staff, :deactivated)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when user is staff admin" do
        setup do
          @user = create(:staff_admin)
        end

        context "when organization context is a different organization" do
          setup do
            @organization = create(:organization)
          end

          should "return false" do
            assert_equal false, @action.call
          end
        end

        context "when organization context is user's organization" do
          should "return true" do
            assert_equal true, @action.call
          end
        end
      end
    end

    context "#index?" do
      should "be an alias to :manage?" do
        assert_alias_rule @policy.call, :index?, :manage?
      end
    end
  end

  context "existing record action" do
    setup do
      @submission = create(:submission)
      @policy = -> {
        Organizations::SubmissionPolicy.new(
          @submission, user: @user
        )
      }
    end

    context "#manage?" do
      setup do
        @action = -> { @policy.call.apply(:manage?) }
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

      context "when user is activated staff" do
        setup do
          @user = create(:staff)
        end

        context "when submission belongs to a different organization" do
          setup do
            ActsAsTenant.with_tenant(create(:organization)) do
              @submission = create(:submission)
            end
          end

          should "return false" do
            assert_equal false, @action.call
          end
        end

        context "when submission belongs to user's organization" do
          should "return true" do
            assert_equal true, @action.call
          end
        end
      end

      context "when user is deactivated staff" do
        setup do
          @user = create(:staff, :deactivated)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when user is staff admin" do
        setup do
          @user = create(:staff_admin)
        end

        context "when submission belongs to a different organization" do
          setup do
            ActsAsTenant.with_tenant(create(:organization)) do
              @submission = create(:submission)
            end
          end

          should "return false" do
            assert_equal false, @action.call
          end
        end

        context "when submission belongs to user's organization" do
          should "return true" do
            assert_equal true, @action.call
          end
        end
      end
    end

    context "#edit?" do
      should "be an alias to :manage?" do
        assert_alias_rule @policy.call, :edit?, :manage?
      end
    end

    context "#update?" do
      should "be an alias to :manage?" do
        assert_alias_rule @policy.call, :update?, :manage?
      end
    end
  end
end
