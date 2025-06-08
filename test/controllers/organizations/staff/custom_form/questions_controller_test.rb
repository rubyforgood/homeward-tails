require "test_helper"
require "action_policy/test_helper"

module Organizations
  module Staff
    module CustomForm
      class QuestionsControllerTest < ActionDispatch::IntegrationTest
        setup do
          @organization = ActsAsTenant.current_tenant
          @question = create(:question, organization: @organization)
          @form = @question.form

          user = create(:person, :admin).user
          sign_in user
        end

        context "authorization" do
          include ActionPolicy::TestHelper

          context "new" do
            should "be authorized" do
              assert_authorized_to(
                :manage?, ::CustomForm::Question,
                with: Organizations::CustomForm::QuestionPolicy
              ) do
                get new_staff_custom_form_form_question_url(@form)
              end
            end
          end

          context "create" do
            setup do
              @params = {
                custom_form_question: attributes_for(:question)
              }
            end

            should "be authorized" do
              assert_authorized_to(
                :manage?, ::CustomForm::Question,
                with: Organizations::CustomForm::QuestionPolicy
              ) do
                post staff_custom_form_form_questions_url(@form), params: @params
              end
            end
          end

          context "edit" do
            should "be authorized" do
              assert_authorized_to(
                :manage?, @question,
                with: Organizations::CustomForm::QuestionPolicy
              ) do
                get edit_staff_custom_form_form_question_url(@form, @question)
              end
            end
          end

          context "update" do
            setup do
              @params = {
                custom_form_question: {
                  name: "new name"
                }
              }
            end

            should "be authorized" do
              assert_authorized_to(
                :manage?, @question,
                with: Organizations::CustomForm::QuestionPolicy
              ) do
                patch staff_custom_form_form_question_url(@form, @question), params: @params
              end
            end
          end

          context "destroy" do
            should "be authorized" do
              assert_authorized_to(
                :manage?, @question,
                with: Organizations::CustomForm::QuestionPolicy
              ) do
                delete staff_custom_form_form_question_url(@form, @question)
              end
            end
          end
        end

        test "should get new" do
          get new_staff_custom_form_form_question_url(@form)

          assert_response :success
          assert_select "h1", text: "New Question"
        end

        context "POST #create" do
          should "create new question" do
            assert_difference("@form.questions.count", 1) do
              post staff_custom_form_form_questions_url(@form), params: {
                custom_form_question: attributes_for(:question)
              }
            end

            assert_response :redirect
            follow_redirect!
            assert_equal "Question saved successfully.", flash.notice
          end

          should "not create question with invalid data" do
            assert_no_difference("@form.questions.count") do
              post staff_custom_form_form_questions_url(@form), params: {
                custom_form_question: {name: ""}
              }
            end

            assert_template :new
          end
        end

        context "GET #edit" do
          should "visit edit page" do
            get edit_staff_custom_form_form_question_url(@form, @question)

            assert_response :success
            assert_select "h1", text: "Edit Question"
          end

          should "not visit edit page of non-existent form" do
            get edit_staff_custom_form_form_question_url(0, @question)

            assert_response :redirect
            follow_redirect!
            assert_equal "Form not found.", flash.alert
          end

          should "not visit edit page of non-existent question" do
            get edit_staff_custom_form_form_question_url(@form, id: 0)

            assert_response :redirect
            follow_redirect!
            assert_equal "Question not found.", flash.alert
          end

          should "not visit edit page of question outside of form" do
            f2 = create(:form, organization: @organization)
            q2 = create(:question, form: f2)

            get edit_staff_custom_form_form_question_url(@form, q2)

            assert_response :redirect
            follow_redirect!
            assert_equal "Question not found.", flash.alert
          end
        end

        context "PATCH #update" do
          should "update question" do
            patch staff_custom_form_form_question_url(@form, @question), params: {
              custom_form_question: {
                name: "new name"
              }
            }

            assert_response :redirect
            follow_redirect!
            assert_equal "Question saved successfully.", flash.notice
          end

          should "not update question with invalid data" do
            patch staff_custom_form_form_question_url(@form, @question), params: {
              custom_form_question: {
                name: ""
              }
            }

            assert_template :edit
          end

          should "not update question belonging to other form" do
            f2 = create(:form, organization: @organization)
            q2 = create(:question, form: f2)

            patch staff_custom_form_form_question_url(@form, q2), params: {
              custom_form_question: {
                name: "new name",
                label: "new label"
              }
            }

            assert_response :redirect
            follow_redirect!
            assert_equal "Question not found.", flash.alert
          end
        end

        context "DELETE #destroy" do
          should "destroy a question" do
            assert_difference("@form.questions.count", -1) do
              delete staff_custom_form_form_question_url(@form, @question)
            end

            assert_response :redirect
            follow_redirect!
            assert_equal "Question was successfully deleted.", flash.notice
          end

          should "not destroy a question belonging to another form" do
            f2 = create(:form, organization: @organization)
            q2 = create(:question, form: f2)

            assert_no_difference("::CustomForm::Question.count") do
              delete staff_custom_form_form_question_url(@form, q2)
            end

            assert_response :redirect
            follow_redirect!
            assert_equal "Question not found.", flash.alert
          end
        end
      end
    end
  end
end
