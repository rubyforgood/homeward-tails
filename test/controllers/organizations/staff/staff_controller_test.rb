require "test_helper"
require "action_policy/test_helper"

class Organizations::Staff::StaffControllerTest < ActionDispatch::IntegrationTest
  setup do
    @staff = create(:person, :super_admin).user
    sign_in @staff
  end

  context "authorization" do
    include ActionPolicy::TestHelper

    context "#index" do
      should "be authorized" do
        assert_authorized_to(
          :index?, User,
          with: Organizations::StaffPolicy
        ) do
          get staff_staff_index_url
        end
      end
    end
  end
end
