require "test_helper"

class StaticPagesTest < ActionDispatch::IntegrationTest
  test "Home page can be accessed" do
    skip("while new ui is implemented")
    # get "/"
    # assert_response :success
    # assert_select "h1", "Be someone's hero adopt a rescue."
  end

  test "FAQ page can be accessed" do
    skip("while new ui is implemented")
    # get "/faq"
    # assert_response :success
    # assert_select "h1", "Frequently Asked Questions"
  end

  test "Contact Us page can be accessed" do
    skip("while new ui is implemented")
    # get "/contacts/new"
    # assert_response :success
    # assert_select "h1", "Contact Us"
  end

  test "Privacy Policy page can be accessed" do
    skip("while new ui is implemented")
    # get "/privacy_policy"
    # assert_response :success
    # assert_select "h1", "Privacy Policy"
  end

  test "Terms and Conditions page can be accessed" do
    skip("while new ui is implemented")
    # get "/terms_and_conditions"
    # assert_response :success
    # assert_select "h1", "Terms and Conditions"
  end

  test "Cookie Policy page can be accessed" do
    skip("while new ui is implemented")
    # get "/cookie_policy"
    # assert_response :success
    # assert_select "h1", "Cookie Policy"
  end

  context "with no tenant" do
    should "render the about us page" do
      get "/about_us"
      assert_response :success
      assert_select "h1", "About"
    end

    should "render the partners page" do
      get "/partners"
      assert_response :success
      assert_select "h1", "Partners"
    end
  end

  context "with a tenant" do
    setup do
      @organization = create(:organization)
    end

    should "return 404 for the about us page" do
      get "/#{@organization.slug}/about_us"
      assert_response :not_found
    end

    should "return 404 for the partners page" do
      get "/#{@organization.slug}/partners"
      assert_response :not_found
    end
  end
end
