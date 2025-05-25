require "test_helper"

module GroupRoleManagement
  class GroupMemberTest < ActiveSupport::TestCase
    def setup
      @person = create(:person)
      @group_member = GroupRoleManagement::GroupMember.new(@person)
    end

    context "#add_group" do
      should "add a group by name if not already a member" do
        assert_difference -> { @person.groups.count }, +1 do
          @group_member.add_group(:adopter)
        end

        assert @person.groups.exists?(name: "adopter")
      end

      should "not add duplicate group associations" do
        assert_difference "@person.groups.count", +1 do
          @group_member.add_group(:fosterer)
          @group_member.add_group(:fosterer)
        end
      end

      should "handle multiple valid group names and deduplicate" do
        assert_difference -> { @person.groups.count }, +2 do
          @group_member.add_group(:adopter, "adopter", :fosterer)
        end

        assert @person.groups.exists?(name: :adopter)
        assert @person.groups.exists?(name: :fosterer)
      end
    end
    context "active_in_group?" do
      should "return true if person is active in group" do
        @group_member.add_group(:adopter)
        assert_equal true, @group_member.active_in_group?(:adopter)
      end

      should "return false if person is not in the group" do
        assert_equal false, @group_member.active_in_group?(:adopter)
      end

      should "return false if person was deactivated in the group" do
        @group_member.add_group(:adopter)
        person_group = @person.person_groups.joins(:group).find_by(groups: {name: :adopter})
        person_group.update!(deactivated_at: Time.current)

        assert_equal false, @group_member.active_in_group?(:adopter)
      end
    end

    context "#deactivated_in_org?" do
      should "return false if person is active in any group" do
        @group_member.add_group(:adopter)

        refute @group_member.deactivated_in_org?
      end

      should "return true if all person group memberships are deactivated" do
        @group_member.add_group(:adopter)
        @group_member.add_group(:fosterer)
        @person.person_groups.each do |pg|
          pg.update!(deactivated_at: Time.current)
        end

        assert @group_member.deactivated_in_org?
      end

      should "return true if person has no group memberships" do
        assert @group_member.deactivated_in_org?
      end
    end
  end
end
