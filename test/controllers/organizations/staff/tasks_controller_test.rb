require "test_helper"
require "action_policy/test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    user = create(:person, :super_admin).user
    sign_in user

    @pet = create(:pet)
    @task = create(:task, pet: @pet)
  end

  context "authorization" do
    include ActionPolicy::TestHelper

    context "#new" do
      should "be authorized" do
        assert_authorized_to(
          :manage?, Task,
          context: {pet: @pet},
          with: Organizations::TaskPolicy
        ) do
          get new_staff_pet_task_url(@pet)
        end
      end
    end

    context "#create" do
      setup do
        @task = build(:task, pet: @pet)
        @params = {
          task: {
            name: @task.name,
            description: @task.description,
            completed: @task.completed
          }
        }
      end

      should "be authorized" do
        assert_authorized_to(
          :manage?, Task,
          context: {pet: @pet},
          with: Organizations::TaskPolicy
        ) do
          post staff_pet_tasks_url(@pet), params: @params
        end
      end
    end

    context "#edit" do
      should "be authorized" do
        assert_authorized_to(
          :manage?, @task,
          with: Organizations::TaskPolicy
        ) do
          get edit_staff_pet_task_url(@pet, @task)
        end
      end
    end

    context "#update" do
      setup do
        @params = {task: {name: "better name"}}
      end

      should "be authorized" do
        assert_authorized_to(
          :manage?, @task,
          with: Organizations::TaskPolicy
        ) do
          patch staff_pet_task_url(@pet, @task), params: @params
        end
      end
    end

    context "#destroy" do
      should "be authorized" do
        assert_authorized_to(
          :manage?, @task,
          with: Organizations::TaskPolicy
        ) do
          delete staff_pet_task_url(@pet, @task)
        end
      end
    end
  end

  test "should get index" do
    get staff_pet_tasks_url(@pet)
    assert_response :success
  end

  test "should get show" do
    get staff_pet_task_url(@pet, @task, format: :turbo_stream)
    assert_response :success
    assert_equal Mime[:turbo_stream], response.media_type
  end
  test "should get new" do
    get new_staff_pet_task_url(@pet)
    assert_response :success
  end

  test "new action should handle missing pet" do
    get new_staff_pet_task_url(-1)
    assert_response :redirect
    assert_redirected_to staff_pets_path
  end

  test "edit action should handle non-existent task" do
    get edit_staff_pet_task_url(@pet, -1)
    assert_response :redirect
    assert_redirected_to staff_pets_path
  end

  test "should allow creating task" do
    freeze_time

    current_time = Time.current

    assert_difference "Task.count", 1 do
      post staff_pet_tasks_url(@pet, format: :turbo_stream), params: {
        task: {
          name: "New Task",
          description: "New Task Description",
          due_date: current_time
        }
      }
    end

    created_task = Task.find_by(name: "New Task")
    assert_equal "New Task", created_task.name
    assert_equal "New Task Description", created_task.description
    assert_equal current_time, created_task.due_date

    assert_response :success
  end

  test "should handle creation failure" do
    freeze_time

    current_time = Time.current

    assert_no_difference "Task.count" do
      post staff_pet_tasks_url(@pet, format: :turbo_stream), params: {
        task: {
          name: "",
          description: "New Task Description",
          due_date: current_time
        }
      }
    end

    assert_response :bad_request
  end

  test "should allow updating a task" do
    freeze_time

    current_time = Time.current

    patch staff_pet_task_path(@pet, @task, format: :turbo_stream), params: {
      task: {
        name: "Updated Name",
        description: "Updated Description",
        due_date: current_time
      }
    }

    @task.reload

    assert_equal "Updated Name", @task.name
    assert_equal "Updated Description", @task.description
    assert_equal current_time, @task.due_date

    assert_response :success
  end

  test "should handle update failure" do
    freeze_time

    current_time = Time.current

    assert_no_changes "@task.name" do
      patch staff_pet_task_path(@pet, @task, format: :turbo_stream), params: {
        task: {
          name: "",
          description: "Updated Description",
          due_date: current_time
        }
      }
    end

    assert_response :bad_request
  end

  test "should handle non-existent task during update" do
    non_existent_task_id = -1
    patch staff_pet_task_path(@pet, non_existent_task_id), params: {task: {name: "Updated Name"}}

    assert_response :redirect
    assert_redirected_to staff_pets_path
  end

  test "destroy action should handle non-existent task" do
    assert_no_difference "Task.count" do
      delete staff_pet_task_url(@pet, -1)
    end
    assert_response :redirect
    assert_redirected_to staff_pets_path
  end

  test "destroy action should remove task with Turbo Stream" do
    assert_difference "Task.count", -1 do
      delete staff_pet_task_url(@pet, @task), as: :turbo_stream
    end

    assert_response :success
    assert_turbo_stream action: "remove", target: @task
  end

  test "should create a new task when recurring task without due date is completed" do
    task = create(:task, pet: @pet, recurring: true)

    assert_difference "Task.count", 1 do
      patch staff_pet_task_path(@pet, task, format: :turbo_stream), params: {
        task: {
          completed: true
        }
      }
    end
  end

  test "should create a new task when recurring task with due date is completed" do
    task = create(:task, pet: @pet, recurring: true, due_date: Date.today + 2, next_due_date_in_days: 4)

    assert_difference "Task.count", 1 do
      patch staff_pet_task_path(@pet, task, format: :turbo_stream), params: {
        task: {
          completed: true
        }
      }
    end
  end

  test "should not create a new task if non-recurring task is completed" do
    task = create(:task, pet: @pet, recurring: false)

    assert_no_difference "Task.count" do
      patch staff_pet_task_path(@pet, task, format: :turbo_stream), params: {
        task: {
          completed: true
        }
      }
    end
  end

  test "should not create a new task if recurring task is updated but not completed" do
    task = create(:task, pet: @pet, recurring: true, completed: true)

    assert_no_difference "Task.count" do
      patch staff_pet_task_path(@pet, task, format: :turbo_stream), params: {
        task: {
          completed: false
        }
      }
    end
  end
end
