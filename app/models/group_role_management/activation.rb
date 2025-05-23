# This is a PORO Model that encapsulates logic for modifying associations on Person/User models

# Methods in this class are delegated to the Person model via the `activation` association.
# This allows calls like `@person.activate!(@group)` to invoke logic defined here.
#
module GroupRoleManagement
  class Activation
    attr_reader :person

    def initialize(person)
      @person = person
    end

    def activate!(group)
      person.person_groups.find_by(group: group).update!(deactivated_at: nil)
    end

    def deactivate!(group)
      person.person_groups.find_by(group: group).update!(deactivated_at: Time.current)
    end
  end
end
