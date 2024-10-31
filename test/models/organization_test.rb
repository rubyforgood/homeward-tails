require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  context "associations" do
    subject { build(:organization) }

    should have_many(:users)
    should have_many(:pets)
    should have_many(:faqs)
    should have_many(:form_answers).dependent(:destroy)
    should have_many(:people)

    should have_one(:form_submission).dependent(:destroy)
    should have_one(:custom_page).dependent(:destroy)
  end

  context "associations" do
    should have_many(:locations)
    should accept_nested_attributes_for(:locations)
  end

  context "validations" do
    should allow_value("123-456-7890").for(:phone_number)
    should allow_value("").for(:phone_number)
    should_not allow_value("invalid_number").for(:phone_number)

    should validate_presence_of(:email)
    should allow_value("i_love_pets365@gmail.com").for(:email)
    should_not allow_value("invalid_email.com").for(:email)

    should allow_value("https://something.com").for(:facebook_url)
    should allow_value("").for(:facebook_url)
    should_not allow_value("http://something.com").for(:facebook_url)

    should allow_value("https://something.com").for(:instagram_url)
    should allow_value("").for(:instagram_url)
    should_not allow_value("http://something.com").for(:instagram_url)

    should allow_value("https://something.com").for(:donation_url)
    should allow_value("").for(:donation_url)
    should_not allow_value("http://something.com").for(:donation_url)

    should validate_presence_of(:slug)
    should allow_value("valid-slug").for(:slug)
    should_not allow_value("invalid/slug").for(:slug)

    should validate_presence_of(:name)
  end

  context "callbacks" do
    subject { build(:organization) }

    should "call normalize phone when saving" do
      assert subject.expects(:normalize_phone).at_least_once
      subject.save
    end
  end
end
