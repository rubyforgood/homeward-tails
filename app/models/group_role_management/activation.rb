# This is a PORO Model that encapsulates logic for modifying associations on Person/User models

# Methods in this class are delegated to the Person model via the `activation` association.
# This allows calls like `@person.activate!(:adopter)` to invoke logic defined here.
#
module GroupRoleManagement
  class Activation
    attr_reader :person

    def initialize(person)
      @person = person
    end

    def activate!(group_or_name)
      person_group = find_person_group!(group_or_name)

      person_group.update!(deactivated_at: nil)
    end

    def deactivate!(group_or_name)
      person_group = find_person_group!(group_or_name)

      person_group.update!(deactivated_at: Time.current)
    end

    private

    def find_person_group!(group_or_name)
      group = case group_or_name
      when Group
        group_or_name
      when String, Symbol
        Group.find_by!(name: group_or_name)
      else
        raise ArgumentError, "Expected Group or Group Name, received #{group_or_name.class.name}"
      end
      person.person_groups.find_by(group_id: group.id)
    end
  end
end
