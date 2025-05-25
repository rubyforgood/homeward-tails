require "test_helper"

module Organizations
  module AdopterFosterer
    class FormAnswerPolicyTest < ActiveSupport::TestCase
      include PetRescue::PolicyAssertions

      setup do
        @policy = -> {
          Organizations::AdopterFosterer::FormAnswerPolicy.new(
            FormAnswer, person: @person, user: @person&.user
          )
        }
      end

      context "relation_scope" do
        setup do
          @person = create(:person)
          @form_submission_one = create(:form_submission, person: @person)
          @form_answer_one = create(:form_answer, form_submission: @form_submission_one)

          @person_two = create(:person)
          @form_submission_two = create(:form_submission, person: @person_two)
          @form_answer_two = create(:form_answer, form_submission: @form_submission_two)
        end

        should "return only the user's form answers" do
          scoped = @policy.call.apply_scope(FormAnswer.all, type: :active_record_relation)

          assert_equal 1, scoped.count
          assert_includes scoped, @form_answer_one
        end
      end

      context "rules" do
        context "#index?" do
          setup do
            @action = -> { @policy.call.apply(:index?) }
          end

          context "when user is nil" do
            setup { @person = nil }
            should "return false" do
              assert_equal false, @action.call
            end
          end

          context "when user is adopter" do
            setup do
              @person = create(:person, :adopter)
            end

            should "return true" do
              assert_equal true, @action.call
            end
          end

          context "when user is admin" do
            setup { @person = create(:person, :admin) }

            should "return false" do
              assert_equal true, @action.call
            end
          end
        end
      end
    end
  end
end
