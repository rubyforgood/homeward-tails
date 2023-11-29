require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user, :verified_staff, :staff_admin)
    set_organization(@user.organization)
    @organization = ActsAsTenant.test_tenant
    @pet = create(:pet)
    @task = create(:task, pet: @pet)
    sign_in @user
  end

  test "should get new" do
    get new_pet_task_url(@pet)
    assert_response :success
  end

  test "new action should handle missing pet" do
    get new_pet_task_url(-1)
    assert_response :redirect
    assert_redirected_to pets_path
  end

  test "create action should handle invalid task parameters" do
    task_name = "Super task"
    post pet_tasks_url(@pet), params: {task: {name: task_name, description: "Some description", completed: false}}
    assert_response :redirect
    assert_redirected_to pet_path(@pet, active_tab: "tasks")
  end

  test "edit action should handle non-existent task" do
    get edit_pet_task_url(@pet, -1)
    assert_response :redirect
    assert_redirected_to pets_path
  end

  test "should handle non-existent task during update" do
    non_existent_task_id = -1
    patch pet_task_path(@pet, non_existent_task_id), params: {task: {name: "Updated Name"}}

    assert_response :redirect
    assert_redirected_to pets_path
  end

  test "destroy action should handle non-existent task" do
    assert_no_difference "Task.count" do
      delete pet_task_url(@pet, -1)
    end
    assert_response :redirect
    assert_redirected_to pets_path
  end
end
