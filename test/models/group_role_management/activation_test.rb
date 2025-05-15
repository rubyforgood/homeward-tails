require "test_helper"

module GroupRoleManagement
  class ActivationTest < ActiveSupport::TestCase
    def setup
      person = create(:person, :adopter, deactivated: true)
      @group = person.groups.find_by(name: :adopter)
      @person_group = person.person_groups.find_by(group_id: @group.id)

      @activation = GroupRoleManagement::Activation.new(person)
    end

    context "#activate!" do
      should "activate using group name" do
        result = @activation.activate!(:adopter)
        assert_equal true, result
        assert_nil @person_group.reload.deactivated_at
      end

      should "activate using group object" do
        result = @activation.activate!(@group)
        assert_equal true, result
        assert_nil @person_group.reload.deactivated_at
      end

      should "raise ActiveRecord::RecordNotFound if group name does not exist" do
        assert_raises(ActiveRecord::RecordNotFound) do
          @activation.activate!(:nonexistent_group)
        end
      end

      should "raise ArgumentError when input is invalid" do
        assert_raises(ArgumentError) do
          @activation.activate!(1234)
        end
      end
    end

    context "#deactivate!" do
      should "deactivate using group name" do
        result = @activation.deactivate!(:adopter)
        assert_equal true, result
        refute_nil @person_group.reload.deactivated_at
      end

      should "deactivate using group object" do
        result = @activation.deactivate!(@group)
        assert_equal true, result
        refute_nil @person_group.reload.deactivated_at
      end

      should "raise ActiveRecord::RecordNotFound if group name does not exist" do
        assert_raises(ActiveRecord::RecordNotFound) do
          @activation.deactivate!(:nonexistent_group)
        end
      end

      should "raise ArgumentError when input is invalid" do
        assert_raises(ArgumentError) do
          @activation.deactivate!(nil)
        end
      end
    end
  end
end
