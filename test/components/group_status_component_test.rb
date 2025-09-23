require "test_helper"

class GroupStatusComponentTest < ViewComponent::TestCase
  context "status" do
    context "when group is present and active" do
      setup do
        @person = create(:person, :adopter)
      end
      should "return :active" do
        component = GroupStatusComponent.new(person: @person, group_names: :adopter)
        assert_equal :active, component.status
      end
    end

    context "when group is present but deactivated" do
      setup do
        @person = create(:person, :adopter, deactivated: true)
      end

      should "return :deactivated" do
        component = GroupStatusComponent.new(person: @person, group_names: :adopter)
        assert_equal :deactivated, component.status
      end
    end

    context "when group is not present" do
      setup do
        @person = create(:person)
      end

      should "return :not_present" do
        component = GroupStatusComponent.new(person: @person, group_names: :adopter)
        assert_equal :not_present, component.status
      end
    end
  end

  context "group name to add" do
    context "when adopter or fosterer group is given" do
      setup do
        @person = create(:person)
      end

      should "return adopter" do
        component = GroupStatusComponent.new(person: @person, group_names: :adopter)
        assert_equal :adopter, component.group_name_to_add
      end

      should "return fosterer" do
        component = GroupStatusComponent.new(person: @person, group_names: :fosterer)
        assert_equal :fosterer, component.group_name_to_add
      end
    end

    context "when staff group names are given" do
      setup do
        @person = create(:person, :adopter)
      end

      should "return the first group name given" do
        component = GroupStatusComponent.new(person: @person, group_names: [:admin, :super_admin])
        assert_equal :admin, component.group_name_to_add
      end
    end
  end
end
