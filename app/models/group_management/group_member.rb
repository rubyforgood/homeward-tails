# This is a PORO Model that encapsulates logic for modifying/retrieving associations on Person/User models

# Methods in this class are delegated to the Person model via the `group_member` association.
# This allows calls like `@person.add_group(:adopter)` to invoke logic defined here.

module GroupManagement
  class GroupMember
    attr_reader :person

    def initialize(person)
      @person = person
    end

    def add_group(*names)
      names.map(&:to_sym).uniq.each do |name|
        unless Group.names.key?(name)
          raise ArgumentError, "Invalid group name: #{name}"
        end
        group = Group.find_or_create_by!(name: name)

        unless person.groups.exists?(id: group.id)
          person.person_groups.create!(group: group)
        end
      end
    end

    def active_in_group?(name)
      person.person_groups.joins(:group)
        .where(deactivated_at: nil, groups: {name: name})
        .exists?
    end

    def deactivated_in_org?
      !person.person_groups
        .joins(:group)
        .where(deactivated_at: nil)
        .exists?
    end
  end
end
