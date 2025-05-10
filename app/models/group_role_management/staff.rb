# This is a PORO Model that encapsulates logic for modifying/retrieving associations on Person/User models

# Methods in this class are delegated to the Person model via the `staff`
# association using the prefix `staff` with the method name.
# This allows calls like `@person.staff_active?` to invoke logic defined here.
# Only `staff?` is used directly (@person.staff?); all other methods must be called using the prefix.

module GroupRoleManagement
  class Staff < GroupMember
    attr_reader :person

    def initialize(person)
      @person = person
    end

    def staff?
      person.groups.exists?(name: %i[admin super_admin])
    end

    def current_group
      person.groups.find_by(name: ["admin", "super_admin"])
    end

    def active?
      person.active_in_group?(current_group&.name)
    end

    def change_group(new_group)
      person.transaction do
        # Remove existing admin/super_admin groups
        person.groups.where(name: [:admin, :super_admin]).each do |group|
          person.groups.destroy(group)
        end

        add_group(new_group)
      end
    end
  end
end
