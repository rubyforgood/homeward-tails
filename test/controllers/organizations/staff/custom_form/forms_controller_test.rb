require "test_helper"
require "action_policy/test_helper"

module Organizations
  module Staff
    module CustomForm
      class FormsControllerTest < ActionDispatch::IntegrationTest
        context "authorization" do
          include ActionPolicy::TestHelper

          setup do
            @organization = ActsAsTenant.current_tenant
            @form = create(:form, organization: @organization)
            user = create(:person, :admin).user

            sign_in user
          end

          context "#new" do
            should "be authorized" do
              assert_authorized_to(
                :manage?, ::CustomForm::Form,
                with: Organizations::CustomForm::FormPolicy
              ) do
                get new_staff_custom_form_form_url
              end
            end
          end

          context "#create" do
            setup do
              @params = {
                custom_form_form: attributes_for(:form)
              }
            end

            should "be authorized" do
              assert_authorized_to(
                :manage?, ::CustomForm::Form,
                with: Organizations::CustomForm::FormPolicy
              ) do
                post staff_custom_form_forms_url, params: @params
              end
            end
          end

          context "#index" do
            should "be authorized" do
              assert_authorized_to(
                :manage?, ::CustomForm::Form,
                with: Organizations::CustomForm::FormPolicy
              ) do
                get staff_custom_form_forms_url
              end
            end

            should "have authorized scope" do
              assert_have_authorized_scope(
                type: :active_record_relation,
                with: Organizations::CustomForm::FormPolicy
              ) do
                get staff_custom_form_forms_url
              end
            end
          end

          context "#show" do
            should "be authorized" do
              assert_authorized_to(
                :manage?, @form,
                with: Organizations::CustomForm::FormPolicy
              ) do
                get staff_custom_form_form_url(@form)
              end
            end
          end

          context "#edit" do
            should "be authorized" do
              assert_authorized_to(
                :manage?, @form,
                with: Organizations::CustomForm::FormPolicy
              ) do
                get edit_staff_custom_form_form_url(@form)
              end
            end
          end

          context "#update" do
            setup do
              @params = {
                custom_form_form: {
                  name: "new name"
                }
              }
            end

            should "be authorized" do
              assert_authorized_to(
                :manage?, @form,
                with: Organizations::CustomForm::FormPolicy
              ) do
                patch staff_custom_form_form_url(@form),
                  params: @params
              end
            end
          end

          context "#destroy" do
            should "be authorized" do
              assert_authorized_to(
                :manage?, @form,
                with: Organizations::CustomForm::FormPolicy
              ) do
                delete staff_custom_form_form_url(@form)
              end
            end
          end
        end

        context "controller" do
          setup do
            @organization = ActsAsTenant.current_tenant
            @form = create(:form)
            @user = create(:person, :admin).user
            sign_in @user
          end

          should "get index" do
            get staff_custom_form_forms_path

            assert_response :success
            assert_select "h2", text: "Forms"
          end

          should "should get new" do
            get new_staff_custom_form_form_path

            assert_response :success
            assert_select "h1", text: "New Form"
          end

          context "POST #create" do
            should "create new form" do
              assert_difference("@organization.forms.count", 1) do
                post staff_custom_form_forms_path, params: {
                  custom_form_form: attributes_for(:form)
                }
              end

              assert_response :redirect
              follow_redirect!
              assert_equal "Form saved successfully.", flash.notice
            end

            should "not create new form with missing params" do
              assert_difference("@organization.forms.count", 0) do
                post staff_custom_form_forms_path, params: {
                  custom_form_form: {
                    name: "",
                    title: ""
                  }
                }
              end

              assert_template :new
            end
          end

          context "GET #show" do
            should "visit show page" do
              get staff_custom_form_form_path(@form)

              assert_response :success
              assert_select "h2", text: @form.name
            end

            should "not visit show page of non-existent form" do
              get staff_custom_form_form_path(id: ::CustomForm::Form.order(:id).last.id + 1)

              assert_response :redirect
              follow_redirect!
              assert_equal "Form not found.", flash.alert
            end
          end

          context "GET #edit" do
            should "visit edit page" do
              get edit_staff_custom_form_form_path(@form)

              assert_response :success
              assert_select "h1", text: "Edit Form"
            end

            should "not visit edit page of non-existent task" do
              get edit_staff_custom_form_form_path(id: ::CustomForm::Form.order(:id).last.id + 1)

              assert_response :redirect
              follow_redirect!
              assert_equal "Form not found.", flash.alert
            end
          end

          context "PATCH #update" do
            should "update form" do
              assert_changes "@form.name" do
                patch staff_custom_form_form_path(@form), params: {
                  custom_form_form: {
                    name: Faker::Lorem.sentence
                  }
                }

                @form.reload
              end

              assert_response :redirect
              follow_redirect!
              assert_equal "Form saved successfully.", flash.notice
            end

            should "not update form with missing param" do
              patch staff_custom_form_form_path(@form), params: {
                custom_form_form: {
                  name: ""
                }
              }

              assert_template :edit
            end
          end

          context "DELETE #destroy" do
            should "destroy a form" do
              assert_difference("@organization.forms.count", -1) do
                delete staff_custom_form_form_path(@form)
              end

              assert_response :redirect
              follow_redirect!
              assert_equal "Form was successfully deleted.", flash.notice
            end
          end
        end
      end
    end
  end
end
