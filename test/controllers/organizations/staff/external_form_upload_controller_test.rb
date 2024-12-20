require "test_helper"

module Organizations
  module Staff
    class ExternalFormUploadControllerTest < ActionDispatch::IntegrationTest
      setup do
        file = fixture_file_upload("google_form_sample.csv", "text/csv")
        @params = {files: file}
        admin = create(:admin)
        sign_in admin
      end

      should "get index" do
        get staff_external_form_upload_index_path
        assert_response :success
      end

      should "Creates new form submission" do
        assert_enqueued_with(job: CsvImportJob) do
          post staff_external_form_upload_index_path, params: @params, as: :turbo_stream
        end

        assert_response :success
        assert_equal "File uploaded for processing", flash[:notice]
      end
    end
  end
end
