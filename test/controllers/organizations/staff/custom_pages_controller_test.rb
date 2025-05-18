require "test_helper"
require "action_policy/test_helper"

class Organizations::Staff::CustomPagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @org = ActsAsTenant.current_tenant
    admin = create(:person, :super_admin).user
    sign_in admin
    @custom_page = create(:custom_page, organization: @org)
  end

  context "authorization" do
    include ActionPolicy::TestHelper

    context "#edit" do
      should "be authorized" do
        assert_authorized_to(
          :manage?, @custom_page, with: Organizations::CustomPagePolicy
        ) do
          get edit_staff_custom_page_url(@custom_page)
        end
      end
    end

    context "#update" do
      setup do
        @params = {custom_page: {hero: "Super Dog", about: "canine caped crusader"}}
      end

      should "be authorized" do
        assert_authorized_to(
          :manage?, @custom_page, with: Organizations::CustomPagePolicy
        ) do
          patch staff_custom_page_url(@custom_page), params: @params
        end
      end
    end
  end
  context "GET #edit" do
    should "get edit page" do
      get edit_staff_custom_page_path
      assert_response :success
    end
  end

  context "PATCH #update" do
    should "update page text" do
      patch staff_custom_page_path(@custom_page), params: {custom_page: {hero: "Super Dog", about: "canine caped crusader"}}
      @custom_page.reload
      assert_response :redirect
      follow_redirect!
      assert_response :success
      assert_equal "Super Dog", @custom_page.hero
      assert_equal "canine caped crusader", @custom_page.about
    end
  end
end
