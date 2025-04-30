# This is a PORO Model that encapsulates logic for modifying associations on Person/User models

# This class adds staff-specific behavior to a Person.
# Access it via `@person.staff`, then call methods like `active?` on that object. (@person.staff.active?)
# Only `staff?` is directly available on Person (@person.staff?); all other methods must be called through `staff`.

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
      person.active_in_group?(current_group.name)
    end

    def change_role_and_group(prev_group, new_group)
      person.transaction do
        person.user.change_role(prev_group, new_group)

        # Remove existing admin/super_admin groups
        person.groups.where(name: [:admin, :super_admin]).each do |group|
          person.groups.destroy(group)
        end

        add_group(new_group)
      end
    end
  end
end
