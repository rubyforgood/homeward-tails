require "test_helper"
require "action_policy/test_helper"

class Organizations::ActivationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    account = create(:person, :admin)
    group = account.groups.find_by(name: :admin)
    @person_group = PersonGroup.find_by(person_id: account.id, group_id: group.id)
    user = create(:person, :super_admin).user
    sign_in user
  end

  test "update activation should modify user deactivated at state" do
    assert_changes -> { @person_group.deactivated_at } do
      patch activation_url(@person_group), params: {person_group: {deactivated: "true"}}, as: :turbo_stream
      @person_group.reload
    end
  end
end
