require "test_helper"

module GroupRoleManagement
  class StaffTest < ActiveSupport::TestCase
    def setup
      @staff_management = -> { GroupRoleManagement::Staff.new(@person) }
    end

    context "#staff?" do
      should "return true if person is admin" do
        @person = create(:person, :admin)
        assert_equal true, @staff_management.call.staff?
      end

      should "return true if person is super admin" do
        @person = create(:person, :super_admin)
        assert_equal true, @staff_management.call.staff?
      end

      should "return false if person is adopter" do
        @person = create(:person, :adopter)
        assert_equal false, @staff_management.call.staff?
      end
    end

    context "#current_group" do
      should "return current admin group if person is admin" do
        @person = create(:person, :admin)
        expected_group = @person.groups.find_by(name: "admin")

        assert_equal expected_group, @staff_management.call.current_group
      end

      should "return current super admin group if person is admin" do
        @person = create(:person, :super_admin)
        expected_group = @person.groups.find_by(name: "super_admin")

        assert_equal expected_group, @staff_management.call.current_group
      end

      should "return nil if person is not staff" do
        @person = create(:person, :adopter)

        assert_nil @staff_management.call.current_group
      end
    end

    context "#active?" do
      should "return true if person is active in the current group" do
        @person = create(:person, :admin)
        @person.stubs(:active_in_group?).with("admin").returns(true)

        assert_equal true, @staff_management.call.active?
      end

      should "return false if person is not active in the current group" do
        @person = create(:person, :admin)
        @person.stubs(:active_in_group?).with("admin").returns(false)

        assert_equal false, @staff_management.call.active?
      end

      should "return false if current group is nil" do
        @person = create(:person)
        @person.stubs(:current_group).returns(nil)

        assert_equal false, @staff_management.call.active?
      end
    end

    context "#change_group" do
      should "remove existing admin group and add the super admin group" do
        @person = create(:person, :admin)
        @staff_management.call.change_group(:super_admin)

        refute @person.groups.exists?(name: "admin")
        assert @person.groups.exists?(name: "super_admin")
      end

      should "remove existing super admin group and add the admin group" do
        @person = create(:person, :super_admin)
        @staff_management.call.change_group(:admin)

        refute @person.groups.exists?(name: "super_admin")
        assert @person.groups.exists?(name: "admin")
      end

      should "raise an error if the group is not admin or super_admin" do
        @person = create(:person, :admin)

        assert_raises(ArgumentError, "Only :admin or :super_admin are valid groups") do
          @staff_management.call.change_group(:adopter)
        end
      end
    end
  end
end
