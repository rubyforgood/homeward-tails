require "test_helper"

class OrganizationAccountRequestControllerTest < ActionDispatch::IntegrationTest
  test "#new" do
    get new_organization_account_request_path

    assert_response :success
  end

  test "#create" do
    assert_emails 1 do
      post organization_account_request_path, params: {
        organization_account_request: {
          name: "Pet lovers",
          requester_name: "Pete Smith",
          phone_number: "2015551234",
          email: "pete@example.com",
          country: "United States",
          province_state: "Colorado",
          city_town: "Golden"
        }
      }
    end

    assert_redirected_to root_path
  end

  test "#create fails" do
    assert_no_emails do
      post organization_account_request_path, params: {
        organization_account_request: {
          requester_name: "Pete Smith",
          phone_number: "2015551234",
          email: "pete@example.com",
          country: "United States",
          province_state: "Colorado",
          city_town: "Golden"
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
