require "test_helper"

module GroupManagement
  class ActivationTest < ActiveSupport::TestCase
    def setup
      person = create(:person, :adopter, deactivated: true)
      @group = person.groups.find_by(name: :adopter)
      @person_group = person.person_groups.find_by(group_id: @group.id)

      @activation = GroupManagement::Activation.new(person)
    end

    context "#activate" do
      should "activate using group" do
        result = @activation.activate(@group)
        assert_equal true, result
        assert_nil @person_group.reload.deactivated_at
      end
    end

    context "#deactivate" do
      should "deactivate using group" do
        result = @activation.deactivate(@group)
        assert_equal true, result
        refute_nil @person_group.reload.deactivated_at
      end
    end
  end
end
