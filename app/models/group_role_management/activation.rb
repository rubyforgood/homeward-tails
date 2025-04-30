# This is a PORO Model that encapsulates logic for modifying associations on Person/User models

# Methods in this class are delegated to from the Person model via the `activation` association.
# This allows calls like `@person.activate!(:adopter)` to invoke logic defined here.
#
module GroupRoleManagement
  class Activation
    attr_reader :person

    def initialize(person)
      @person = person
    end

    def activate!(group_or_name)
      @group = find_group!(group_or_name)

      begin
        person.transaction do
          person.user.add_role(@group.name, @group.organization)
          person_group.update!(deactivated_at: nil)
        end
      rescue => e
        "Activation failed: #{e.message}"
      end
    end

    def deactivate!(group_or_name)
      @group = find_group!(group_or_name)
      begin
        person.transaction do
          person.user.remove_role(@group.name, @group.organization)
          person_group.update!(deactivated_at: Time.current)
        end
      rescue => e
        "Deactivation failed: #{e.message}"
      end
    end

    private

    def person_group
      person.person_groups.find_sole_by(group_id: @group.id)
    end

    def find_group!(group_or_name)
      case group_or_name
      when Group
        group_or_name
      when String, Symbol
        Group.find_sole_by!(name: group_or_name)
      else
        raise ArgumentError, "Expected Group or Group Name, got #{group_or_name.class.name}"
      end
    end
  end
end
