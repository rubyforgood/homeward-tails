require "test_helper"

class GroupTest < ActiveSupport::TestCase
  context "associations" do
    should have_many(:person_groups)
    should have_many(:people).through(:person_groups)
  end

  context "validations" do
    should "does not allow duplicate names within the same organization" do
      group = create(:group, :adopter)
      duplicate = Group.new(name: :adopter, organization: group.organization)

      refute duplicate.valid?
    end

    should "allows same name in different organizations" do
      org1 = create(:organization)
      org2 = create(:organization)
      Group.create!(name: :adopter, organization: org1)
      ActsAsTenant.with_tenant(org2) do
        @other_group = Group.new(name: :adopter, organization: org2)

        assert @other_group.valid?
      end
    end
  end
end
