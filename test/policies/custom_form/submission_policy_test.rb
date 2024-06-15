require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class CustomForm::SubmissionPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  context "relation_scope" do
    setup do
      policy = -> {
        CustomForm::SubmissionPolicy.new(CustomForm::Submission, user: @user)
      }
      target = -> { CustomForm::Submission.all }
      @scope = -> {
        policy.call.apply_scope(target.call, type: :active_record_relation)
          .pluck(:id)
      }
    end

    context "when user is adopter with profile" do
      setup do
        @user = create(:adopter, :with_profile)
      end

      context "when there are submissions that do not belong to user" do
        setup do
          @user_submissions = [
            create(:submission, user: @user),
            create(:submission, user: @user)
          ]
          @other_submission = create(:submission)
        end

        should "return only user's submissions" do
          expected = @user_submissions.map(&:id)

          assert_equal(expected, @scope.call)
        end
      end

      context "when user has no submissions" do
        setup do
          @other_submission = create(:submission)
        end

        should "return empty array" do
          assert_equal([], @scope.call)
        end
      end
    end
  end

  context "#index?" do
    setup do
      @policy = -> {
        CustomForm::SubmissionPolicy.new(CustomForm::Submission, user: @user)
      }
      @action = -> { @policy.call.apply(:index?) }
    end

    context "when user is nil" do
      setup do
        @user = nil
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user not associated with adopter account" do
      setup do
        @user = create(:user)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is adopter without profile" do
      setup do
        @user = create(:adopter)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is adopter with profile" do
      setup do
        @user = create(:adopter, :with_profile)
      end

      should "return true" do
        assert_equal true, @action.call
      end
    end

    context "when user is fosterer with profile" do
      setup do
        @user = create(:fosterer, :with_profile)
      end

      should "return true" do
        assert_equal true, @action.call
      end
    end
  end

  context "#create?" do
    setup do
      @pet = create(:pet)
      @policy = -> {
        CustomForm::SubmissionPolicy.new(CustomForm::Submission, user: @user,
          pet: @pet)
      }
      @action = -> { @policy.call.apply(:create?) }
    end

    context "when user is nil" do
      setup do
        @user = nil
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user not associated with adopter account" do
      setup do
        @user = create(:user)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is adopter without profile" do
      setup do
        @user = create(:adopter)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is adopter with profile" do
      setup do
        @user = create(:adopter, :with_profile)
      end

      context "when pet submission is paused" do
        setup do
          @pet = create(:pet, application_paused: true)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when pet submission is not paused" do
        setup do
          @pet = create(:pet, application_paused: false)
        end

        context "when user already has an existing submission for the pet" do
          setup do
            @existing_sub = create(:submission, user: @user, pet: @pet)
          end

          should "return false" do
            assert_equal false, @action.call
          end
        end

        context "when user has not applied for the pet" do
          should "return true" do
            # debugger
            assert_equal true, @action.call
          end
        end
      end
    end

    context "when user is fosterer with profile" do
      setup do
        @user = create(:fosterer, :with_profile)
      end

      should "return true" do
        assert_equal true, @action.call
      end
    end
  end

  context "existing record action" do
    setup do
      @adopter_submission = create(:submission)
      @policy = -> {
        CustomForm::SubmissionPolicy.new(@adopter_submission, user: @user)
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

      context "when adopter account does not belong to user" do
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

        context "when user is active staff" do
          setup do
            @user = create(:staff)
          end

          should "return false" do
            assert_equal false, @action.call
          end
        end

        context "when user is staff admin" do
          setup do
            @user = create(:staff_admin)
          end

          should "return false" do
            assert_equal false, @action.call
          end
        end
      end

      context "when adopter account belongs to user" do
        setup do
          @user = @adopter_submission.adopter_foster_account.user
        end

        should "return true" do
          assert_equal true, @action.call
        end
      end
    end
  end
end
