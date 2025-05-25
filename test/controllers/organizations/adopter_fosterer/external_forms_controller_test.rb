require "test_helper"

class Organizations::AdopterFosterer::ExternalFormsControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = create(:person, :adopter).user
    sign_in user
  end

  test "should get index" do
    get adopter_fosterer_external_form_index_url
    assert_response :success
  end
end
