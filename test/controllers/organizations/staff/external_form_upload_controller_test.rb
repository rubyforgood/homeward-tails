require "test_helper"

module Organizations
  module Staff
    class ExternalFormUploadControllerTest < ActionDispatch::IntegrationTest
      setup do
        file = fixture_file_upload("google_form_sample.csv", "text/csv")
        @params = {files: file}
        admin = create(:admin)
        @adopter = create(:adopter, email: "adopter1111@alta.com")
        @adopter2 = create(:adopter, email: "no_answer_will_be_created@alta.com")
        sign_in admin
      end

      test "Creates new form submission" do
        assert_difference "@adopter.person.form_submissions.count" do
          post staff_external_form_upload_index_path, params: @params
        end
      end

      test "It does not create form answers for adopter2" do
        assert_no_difference "@adopter2.person.form_submissions.count" do
          post staff_external_form_upload_index_path, params: @params
        end
      end
    end
  end
end
