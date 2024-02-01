require "test_helper"

class DefaultPetTaskTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_numericality_of(:due_in_days).only_integer.is_greater_than_or_equal_to(0).allow_nil

  test "should have valid factory" do
    assert build(:default_pet_task).valid?
  end

  test "should belong to an organization" do
    default_pet_task = build(:default_pet_task)
    assert_difference("default_pet_task.organization.default_pet_tasks.count", 1) do
      default_pet_task.save
    end
  end
end
