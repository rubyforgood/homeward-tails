require "test_helper"
require "action_policy/test_helper"

class Organizations::ActivationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = ActsAsTenant.current_tenant
    @staff = create(:admin)
    sign_in @staff
  end

  test "update activation should modify user deactivated at state" do
    user = create(:super_admin)
    sign_in user

    assert_changes -> { User.find(@staff.id).deactivated_at } do
      patch activations_url(user_id: @staff.id), as: :turbo_stream
    end
  end
end
