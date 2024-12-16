require "test_helper"

class OrganizationAccountRequestsMailerTest < ActionMailer::TestCase
  test "create new organization account request" do
    organization_account_request_params = {
      name: "Test Organization",
      slug: "test_organ",
      requester_name: "John Doe",
      phone_number: "201-555-7890",
      email: "test@example.com",
      country: "Country Name",
      city_town: "City Name",
      province_state: "State Name"
    }

    mail = OrganizationAccountRequestsMailer.with(
      organization_account_request_params
    ).new_organization_account_request.deliver_now

    assert_equal "New Organization Account Request", mail.subject
    assert_equal [Rails.application.config.from_email], mail.to
    assert_equal [Rails.application.config.from_email], mail.from

    assert_match organization_account_request_params[:name], mail.body.encoded
    assert_match organization_account_request_params[:requester_name], mail.body.encoded
    assert_match organization_account_request_params[:phone_number], mail.body.encoded
    assert_match organization_account_request_params[:email], mail.body.encoded
    assert_match organization_account_request_params[:country], mail.body.encoded
    assert_match organization_account_request_params[:city_town], mail.body.encoded
    assert_match organization_account_request_params[:province_state], mail.body.encoded
  end
end
