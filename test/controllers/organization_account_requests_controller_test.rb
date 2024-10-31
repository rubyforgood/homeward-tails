require "test_helper"

class OrganizationAccountRequestControllerTest < ActionDispatch::IntegrationTest
  test "#new" do
    get new_organization_account_request_path

    assert_response :success
    assert_select "h1", "New organization account request"
  end

  test "#create" do
    assert_emails 1 do
      post organization_account_requests_path, params: {
        organization: {
          name: "Pet lovers",
          slug: "pet-lovers",
          requester_name: "Pete Smith",
          phone_number: 1234567890,
          email: "pete@example.com",
          locations: {
            country: "United States",
            province_state: "Colorado",
            city_town: "Golden"
          }
        }
      }
    end

    assert_redirected_to root_path
  end

  test "#create fails" do
    assert_no_emails do
      post organization_account_requests_path, params: {
        organization: {
          name: "Pet lovers",
          requester_name: "Pete Smith",
          phone_number: 1234567890,
          email: "pete@example.com",
          locations: {
            country: "United States",
            province_state: "Colorado",
            city_town: "Golden"
          }
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
