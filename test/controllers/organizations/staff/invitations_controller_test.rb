require "test_helper"
require "action_policy/test_helper"

class Organizations::Staff::InvitationsControllerTest < ActionDispatch::IntegrationTest
  context "#create" do
    setup do
      user = create(:person, :super_admin).user
      sign_in user
    end

    should "assign super admin role when super admin is invited" do
      invitation_params = {
        user: attributes_for(:user)
          .except(:password, :encrypted_password, :tos_agreement)
          .merge(roles: "super_admin", first_name: "john", last_name: "doe")
      }

      post user_invitation_url, params: invitation_params

      persisted_person = Person.find_by(email: invitation_params[:user][:email])

      assert_equal true, persisted_person.active_in_group?(:super_admin)
    end

    should "assign admin role when admin is invited" do
      invitation_params = {
        user: attributes_for(:user)
          .except(:password, :encrypted_password, :tos_agreement)
          .merge(roles: "admin", first_name: "john", last_name: "doe")
      }

      post user_invitation_url, params: invitation_params

      persisted_person = Person.find_by(email: invitation_params[:user][:email])

      assert_equal true, persisted_person.active_in_group?(:admin)
    end
  end

  context "authorization" do
    include ActionPolicy::TestHelper

    setup do
      @organization = ActsAsTenant.current_tenant
      user = create(:person, :super_admin).user
      sign_in user
    end

    context "#new" do
      should "raise NotImplementedError" do
        assert_raises(NotImplementedError, "Do not use the 'new' action in Staff::InvitationsController.") do
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
            email: "john@example.com"
          }
        }
      end

      context "with params including {roles: 'super_admin'}" do
        setup do
          @params[:user][:roles] = "super_admin"
        end

        should "be authorized" do
          assert_authorized_to(
            :create?, User,
            with: Organizations::StaffInvitationPolicy
          ) do
            post user_invitation_url, params: @params
          end
        end
      end

      context "with params including {roles: 'staff'}" do
        setup do
          @params[:user][:roles] = "admin"
        end

        should "be authorized" do
          assert_authorized_to(
            :create?, User,
            with: Organizations::StaffInvitationPolicy
          ) do
            post user_invitation_url, params: @params
          end
        end
      end

      context "with params including {roles: 'fosterer'}" do
        setup do
          @params[:user][:roles] = "fosterer"
        end

        should "be authorized" do
          assert_authorized_to(
            :create?, User,
            with: Organizations::FostererInvitationPolicy
          ) do
            post user_invitation_url, params: @params
          end
        end
      end

      context "with params including invalid roles" do
        setup do
          @params[:user][:roles] = "wizard"
        end

        should "be authorized" do
          assert_authorized_to(
            :create?, User,
            with: Organizations::InvitationPolicy
          ) do
            post user_invitation_url, params: @params
          end
        end
      end

      context "with params missing roles" do
        should "be authorized" do
          assert_authorized_to(
            :create?, User,
            with: Organizations::InvitationPolicy
          ) do
            post user_invitation_url, params: @params
          end
        end
      end
    end
  end
end
