require "test_helper"

class Organizations::DefaultPetTaskServiceTest < ActiveSupport::TestCase
  test "creates tasks from the organization's default tasks" do
    default_task = create(:default_pet_task)
    pet = create(:pet)

    Organizations::DefaultPetTaskService.new(pet).create_tasks

    assert_equal 1, pet.tasks.count
    assert_equal default_task.name, pet.tasks.first.name
    assert_nil pet.tasks.first.due_date
  end

  test "creates tasks with due_date set based on the default task's due_in_days" do
    create(:default_pet_task, due_in_days: 5)
    pet = create(:pet)

    Organizations::DefaultPetTaskService.new(pet).create_tasks

    assert_equal 5.days.from_now.beginning_of_day, pet.tasks.first.due_date
  end

  test "creates tasks with recurring" do
    create(:default_pet_task, recurring: true)
    pet = create(:pet)

    Organizations::DefaultPetTaskService.new(pet).create_tasks

    assert pet.tasks.first.recurring?
  end

  test "creates tasks with recurring and due in days" do
    create(:default_pet_task, recurring: true, due_in_days: 5)
    pet = create(:pet)

    Organizations::DefaultPetTaskService.new(pet).create_tasks

    assert pet.tasks.first.recurring?
    assert_equal 5, pet.tasks.first.next_due_date_in_days
    assert_equal 5.days.from_now.beginning_of_day, pet.tasks.first.due_date
  end

  test "creates tasks matching pet species" do
    create(:default_pet_task, name: "General default task")
    create(:default_pet_task, name: "Dog default task", species: "Dog")
    create(:default_pet_task, name: "Cat default task", species: "Cat")
    dog = create(:pet, species: 1)
    kitten = create(:pet, species: 2)

    Organizations::DefaultPetTaskService.new(dog).create_tasks
    Organizations::DefaultPetTaskService.new(kitten).create_tasks

    assert_equal dog.species, "Dog"
    assert_equal dog.tasks.pluck(:name).sort, ["Dog default task", "General default task"]

    assert_equal kitten.species, "Cat"
    assert_equal kitten.tasks.pluck(:name).sort, ["Cat default task", "General default task"]
  end
end
