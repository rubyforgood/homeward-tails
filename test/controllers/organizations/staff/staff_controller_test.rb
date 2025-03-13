require "test_helper"
require "action_policy/test_helper"

class Organizations::Staff::StaffControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = ActsAsTenant.current_tenant
    @staff = create(:admin)
    sign_in @staff
  end

  context "authorization" do
    include ActionPolicy::TestHelper

    context "#index" do
      should "be authorized" do
        assert_authorized_to(
          :index?, User,
          context: {organization: @organization},
          with: Organizations::UserPolicy
        ) do
          get staff_staff_index_url
        end
      end

      # Authorized scope requires the User.organization_id to exist.
      # Explicitly filter users by the current organization instead
      # of relying on authorized_scope. See User.staff.
      #
      #       context "when user is authorized" do
      #         setup do
      #           user = create(:super_admin)
      #           sign_in user
      #         end
      #
      #         should "have authorized scope" do
      #           assert_have_authorized_scope(
      #             type: :active_record_relation, with: Organizations::UserPolicy
      #           ) do
      #             get staff_staff_index_url
      #           end
      #         end
      #       end
    end
  end
end
