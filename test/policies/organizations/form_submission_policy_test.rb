require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
module Organizations
  class FormSubmissionPolicyTest < ActiveSupport::TestCase
    include PetRescue::PolicyAssertions

    context "context only action" do
      setup do
        @policy = -> {
          Organizations::FormSubmissionPolicy.new(FormSubmission, person: @person, user: @person&.user)
        }
      end

      context "#manage?" do
        setup do
          @action = -> { @policy.call.apply(:manage?) }
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

        context "when user is deactivated admin" do
          setup do
            @person = create(:person, :admin, deactivated: true)
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
      end

      context "#index?" do
        should "be an alias to :manage?" do
          assert_alias_rule @policy.call, :index?, :manage?
        end
      end
    end

    context "existing record action" do
      setup do
        @form_submission = create(:form_submission)
        @policy = -> {
          Organizations::FormSubmissionPolicy.new(@form_submission, person: @person, user: @person&.user)
        }
      end

      context "#manage?" do
        setup do
          @action = -> { @policy.call.apply(:manage?) }
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

          context "when FormSubmission belongs to a different organization" do
            setup do
              ActsAsTenant.with_tenant(create(:organization)) do
                @form_submission = create(:form_submission)
              end
            end

            should "return false" do
              assert_equal false, @action.call
            end
          end

          context "when FormSubmission belongs to admin organization" do
            should "return true" do
              assert_equal true, @action.call
            end
          end
        end

        context "when user is deactivated admin" do
          setup do
            @person = create(:person, :admin, deactivated: true)
          end

          should "return false" do
            assert_equal false, @action.call
          end
        end

        context "when user is super admin" do
          setup do
            @person = create(:person, :super_admin)
          end

          context "when FormSubmission belongs to a different organization" do
            setup do
              ActsAsTenant.with_tenant(create(:organization)) do
                @form_submission = create(:form_submission)
              end
            end

            should "return false" do
              assert_equal false, @action.call
            end
          end

          context "when FormSubmission belongs to admin organization" do
            should "return true" do
              assert_equal true, @action.call
            end
          end
        end
      end
    end
  end
end
