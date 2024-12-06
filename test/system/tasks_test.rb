require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  setup do
    user = create(:admin)
    @pet = create(:pet)

    sign_in user
  end

  test "creates a recurring task with a due date without redirecting" do
    due_date = (Date.current + 3.days)

    visit staff_pet_path(@pet, active_tab: "tasks")

    click_link(href: new_staff_pet_task_path(@pet))
    fill_in "Name", with: "Recurring Task"
    fill_in "Due date", with: due_date.strftime("%Y-%m-%d")
    check "recur"
    fill_in "Next due date in (days)", with: 5
    fill_in "Description", with: "Recurring task description"
    click_on "Create Task"

    assert_text "Recurring Task"
    assert_text "Due Date - #{due_date.strftime("%d %b")}"
    assert has_current_path?(staff_pet_path(@pet, active_tab: "tasks"))
  end

  test "creates a recurring task without a due date without redirecting" do
    visit staff_pet_path(@pet, active_tab: "tasks")

    click_link(href: new_staff_pet_task_path(@pet))
    fill_in "Name", with: "Recurring Task"
    check "recur"
    fill_in "Description", with: "Recurring task description"
    click_on "Create Task"

    assert_text "Recurring Task"
    assert has_current_path?(staff_pet_path(@pet, active_tab: "tasks"))
  end

  test "marking a recurring task without due date as complete creates and displays a new task without redirecting" do
    recurring_task = create(:task, recurring: true, pet: @pet, name: "recurring task")

    visit staff_pet_path(@pet, active_tab: "tasks")

    within("#edit_task_#{recurring_task.id}") do
      check "task_completed"
    end

    find("input#flexSwitchCheckChecked").click # Toggle to show completed tasks.

    assert_text("recurring task", count: 2)
    assert has_current_path?(staff_pet_path(@pet, active_tab: "tasks"))
  end

  test "marking a recurring task with due date as complete creates and displays a new task without redirecting" do
    due_date = (Date.current + 2.days)
    recurring_task_with_due_date = create(:task, recurring: true, pet: @pet, name: "recurring task with due date", due_date: due_date, next_due_date_in_days: 4)

    visit staff_pet_path(@pet, active_tab: "tasks")

    within("#edit_task_#{recurring_task_with_due_date.id}") do
      check "task_completed"
    end

    find("input#flexSwitchCheckChecked").click # Toggle to show completed tasks.

    assert_text("recurring task with due date", count: 2)
    assert has_current_path?(staff_pet_path(@pet, active_tab: "tasks"))
  end

  test "doesn't incomplete completed recurring task" do
    recurring_task = create(:task, recurring: true, completed: true, pet: @pet, name: "completed recurring task")
    visit staff_pet_path(@pet, active_tab: "tasks")
    find("input#flexSwitchCheckChecked").click # Toggle to show completed tasks.

    within "#edit_task_#{recurring_task.id}" do
      assert_nothing_raised do
        accept_alert do
          find(".form-check").click
        end
      end
    end
  end

  test "allows user to update a recurring task by making it un-recurring" do
    due_date = (Date.current + 1.day)
    recurring_task = create(:task, recurring: true, completed: false, pet: @pet, name: "recurring task", due_date: due_date, next_due_date_in_days: 5)
    visit staff_pet_path(@pet, active_tab: "tasks")

    click_link("Edit")
    within("#task_#{recurring_task.id}", match: :first) do
      uncheck "recur"
    end

    assert_equal "", find("#next-due").value

    click_on "Update Task"
    assert_no_text "Update Task"
  end

  test "can close new task form with cancel button without redirecting" do
    visit staff_pet_path(@pet, active_tab: "tasks")
    click_link(href: new_staff_pet_task_path(@pet))
    click_link("Cancel")

    assert has_current_path?(staff_pet_path(@pet, active_tab: "tasks"))
    assert_no_text "Cancel"
  end

  test "can close edit task form with cancel button without redirecting" do
    task = create(:task, pet: @pet)
    visit staff_pet_path(@pet, active_tab: "tasks")
    click_link(href: edit_staff_pet_task_path(@pet, task))
    click_link("Cancel")

    assert has_current_path?(staff_pet_path(@pet, active_tab: "tasks"))
    assert_no_text "Cancel"
  end

  test "can close one open task form with its cancel button without closing other open task forms" do
    task1 = create(:task, pet: @pet)
    task2 = create(:task, pet: @pet)

    visit staff_pet_path(@pet, active_tab: "tasks")

    click_link(href: edit_staff_pet_task_path(@pet, task1))
    click_link(href: edit_staff_pet_task_path(@pet, task2))

    assert_link("Cancel", count: 2)

    click_link("Cancel", match: :first)

    assert has_current_path?(staff_pet_path(@pet, active_tab: "tasks"))
    assert_link("Cancel", count: 1)
  end
end
