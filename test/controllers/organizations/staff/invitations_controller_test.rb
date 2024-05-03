require "test_helper"
require "action_policy/test_helper"

class Organizations::Staff::InvitationsControllerTest < ActionDispatch::IntegrationTest
  context "#create" do
    setup do
      user = create(:staff_admin)
      sign_in user
    end

    should "assign admin role when admin is invited" do
      invitation_params = {
        user: attributes_for(:user)
          .except(:password, :encrypted_password, :tos_agreement)
          .merge(roles: "admin")
      }

      post user_invitation_url, params: invitation_params

      persisted_user = User.find_by(email: invitation_params[:user][:email])
      has_role = persisted_user.has_role?(:admin, ActsAsTenant.current_tenant)

      assert_equal has_role, true
    end

    should "assign staff role when staff is invited" do
      invitation_params = {
        user: attributes_for(:user)
          .except(:password, :encrypted_password, :tos_agreement)
          .merge(roles: "staff")
      }

      post user_invitation_url, params: invitation_params

      persisted_user = User.find_by(email: invitation_params[:user][:email])
      has_role = persisted_user.has_role?(:staff, ActsAsTenant.current_tenant)

      assert_equal has_role, true
    end
  end

  context "authorization" do
    include ActionPolicy::TestHelper

    setup do
      @organization = ActsAsTenant.current_tenant
      user = create(:staff_admin)
      sign_in user
    end

    context "#new" do
      should "be authorized" do
        assert_authorized_to(
          :create?, StaffAccount,
          context: {organization: @organization},
          with: Organizations::InvitationPolicy
        ) do
          get new_user_invitation_url
        end
      end
    end

    context "#create" do
      setup do
        @params = {
          user: {
            first_name: "John",
            last_name: "Doe",
            email: "john@example.com",
            roles: "staff"
          }
        }
      end

      should "be authorized" do
        assert_authorized_to(
          :create?, StaffAccount,
          context: {organization: @organization},
          with: Organizations::InvitationPolicy
        ) do
          post user_invitation_url, params: @params
        end
      end
    end
  end
end
