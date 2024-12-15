require "test_helper"

module Organizations
  module Staff
    class ExternalFormUploadControllerTest < ActionDispatch::IntegrationTest
      context "success" do
        setup do
          file = fixture_file_upload("google_form_sample.csv", "text/csv")
          @params = {files: file}
          admin = create(:admin)
          @adopter = create(:adopter, email: "adopter1111@alta.com")
          @adopter2 = create(:adopter, email: "no_answer_will_be_created@alta.com")
          sign_in admin
        end

        should "Creates new form submission" do
          assert_difference "@adopter.person.form_submissions.count" do
            post staff_external_form_upload_index_path, params: @params
          end
        end

        should "It does not create form answers for adopter2" do
          assert_no_difference "@adopter2.person.form_submissions.count" do
            post staff_external_form_upload_index_path, params: @params
          end
        end

        should "shows success feedback" do
          post staff_external_form_upload_index_path, params: @params, as: :turbo_stream

          assert_response :success
          assert_turbo_stream(action: "replace", count: 1) do
            assert_select "h5", text: "File successfully scanned"
          end
        end
      end

      context "error" do
        setup do
          file = fixture_file_upload("google_form_error_sample.csv", "text/csv")
          @params = {files: file}
          admin = create(:admin)
          create(:adopter, email: "adopter1234@alta.com")
          sign_in admin
        end

        should "shows error feedback" do
          post staff_external_form_upload_index_path, params: @params, as: :turbo_stream

          assert_response :success
          assert_turbo_stream(action: "replace", count: 1) do
            assert_select "h5", text: "File scanned: 1 error(s) present"
          end
        end
      end
    end
  end
end
