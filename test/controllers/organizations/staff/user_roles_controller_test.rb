require "test_helper"
require "action_policy/test_helper"

class Organizations::Staff::UserRolesControllerTest < ActionDispatch::IntegrationTest
  context "authorization" do
    include ActionPolicy::TestHelper

    setup do
      @organization = ActsAsTenant.current_tenant
      user = create(:person, :super_admin).user
      sign_in user
      @account = create(:person, :admin)
    end

    context "#to_admin" do
      should "be authorized" do
        assert_authorized_to(
          :change_role?, @account,
          with: Organizations::UserRolesPolicy
        ) do
          post staff_user_to_admin_url(@account), headers: {"HTTP_REFERER" => "http://www.example.com/"}
        end
      end
    end

    context "#to_super_admin" do
      should "be authorized" do
        assert_authorized_to(
          :change_role?, @account,
          with: Organizations::UserRolesPolicy
        ) do
          post staff_user_to_super_admin_url(@account), headers: {"HTTP_REFERER" => "http://www.example.com/"}
        end
      end
    end
  end
  teardown do
    :after_teardown
  end

  context "#to_admin" do
    setup do
      @organization = ActsAsTenant.current_tenant
      @user = create(:person, :super_admin).user
      @account = create(:person, :super_admin)
      sign_in @user
    end

    should "change role from super admin to admin" do
      post staff_user_to_admin_url(@account), headers: {"HTTP_REFERER" => "http://www.example.com/"}
      assert_response :redirect
      follow_redirect!

      assert_equal "Account changed to Admin", flash.notice

      assert_equal true, @account.active_in_group?(:admin)
    end

    should "change role from admin to super admin with turbo" do
      post staff_user_to_admin_url(@account), as: :turbo_stream

      assert_response :success
      assert_turbo_stream(action: "replace", count: 3) do
        assert_select "button", text: "Admin"
      end
      assert_equal "Account changed to Admin", flash.notice
    end

    should "not allow user to change own role" do
      post staff_user_to_admin_url(@user), headers: {"HTTP_REFERER" => "http://www.example.com/"}

      assert_equal false, @account.active_in_group?(:admin)
    end

    should "receive alert if role is not changed" do
      Person.any_instance.stubs(:staff_change_group).returns(false)
      post staff_user_to_admin_url(@account), headers: {"HTTP_REFERER" => "http://www.example.com/"}

      assert_response :redirect
      follow_redirect!

      assert_equal "Error changing role", flash.alert
    end

    should "receive alert via turbo if role is not changed" do
      Person.any_instance.stubs(:staff_change_group).returns(false)
      post staff_user_to_admin_url(@account), as: :turbo_stream

      assert_equal "Error changing role", flash.alert
    end
  end

  context "#to_super_admin" do
    setup do
      @organization = ActsAsTenant.current_tenant
      @user = create(:person, :super_admin).user
      @account = create(:person, :admin)
      sign_in @user
    end

    should "change role from admin to super admin" do
      post staff_user_to_super_admin_url(@account), headers: {"HTTP_REFERER" => "http://www.example.com/"}
      assert_response :redirect
      follow_redirect!

      assert_equal "Account changed to Super Admin", flash.notice

      assert_equal true, @account.active_in_group?(:super_admin)
    end

    should "change role from staff to admin with turbo" do
      post staff_user_to_super_admin_url(@account), as: :turbo_stream

      assert_response :success
      assert_turbo_stream(action: "replace", count: 3) do
        assert_select "button", text: "Super Admin"
      end
      assert_equal "Account changed to Super Admin", flash.notice
    end

    should "receive alert if role is not changed" do
      Person.any_instance.stubs(:staff_change_group).returns(false)
      post staff_user_to_super_admin_url(@account), headers: {"HTTP_REFERER" => "http://www.example.com/"}

      assert_response :redirect
      follow_redirect!

      assert_equal "Error changing role", flash.alert
    end

    should "receive alert via turbo if role is not changed" do
      Person.any_instance.stubs(:staff_change_group).returns(false)
      post staff_user_to_super_admin_url(@account), as: :turbo_stream

      assert_equal "Error changing role", flash.alert
    end
  end
end
