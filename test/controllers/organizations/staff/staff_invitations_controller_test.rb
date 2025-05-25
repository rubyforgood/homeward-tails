require "test_helper"
require "action_policy/test_helper"

class Organizations::Staff::StaffInvitationsControllerTest < ActionDispatch::IntegrationTest
  context "authorization" do
    include ActionPolicy::TestHelper

    setup do
      @organization = ActsAsTenant.current_tenant
      user = create(:person, :super_admin).user
      sign_in user
    end

    context "#new" do
      should "be authorized" do
        assert_authorized_to(
          :create?, User,
          with: Organizations::StaffInvitationPolicy
        ) do
          get new_staff_staff_invitation_url
        end
      end
    end
  end
end
