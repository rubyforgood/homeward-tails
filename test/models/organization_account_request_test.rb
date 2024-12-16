require "test_helper"

class OrganizationAccountRequestTest < ActiveSupport::TestCase
  context "validations" do
    should allow_value("201-555-7890").for(:phone_number)
    should_not allow_value("invalid_number").for(:phone_number)

    should allow_value("i_love_pets365@gmail.com").for(:email)
    should_not allow_value("invalid_email.com").for(:email)

    should validate_presence_of(:email)
    should validate_presence_of(:name)
    should validate_presence_of(:phone_number)
    should validate_presence_of(:country)
    should validate_presence_of(:city_town)
    should validate_presence_of(:province_state)
  end
end
