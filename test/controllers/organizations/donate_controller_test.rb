require "test_helper"

class Organization::DonateControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    Current.organization = create(:organization)

    @admin = create(:person, :admin)

    @adopter = create(:person, :adopter)
  end

  context "Donate Page" do
    should "accessible to unauthenticated users" do
      get donate_index_path
      assert_response :success
      assert_select "h1", /Give them/
    end

    should "shows Admin link in navbar for admin users" do
      sign_in @admin.user
      get donate_index_path
      assert_response :success
      assert_select "nav", /Admin/
    end

    should "shows Dashboard link in navbar for adopter/fosterer users" do
      sign_in @adopter.user
      get donate_index_path
      assert_response :success
      assert_select "nav", /Dashboard/
    end
  end
end
