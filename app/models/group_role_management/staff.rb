module GroupRoleManagement
  class Staff
    attr_reader :person

    def initialize(person)
      @person = person
    end

    def staff?
      person.groups.exists?(name: %i[admin super_admin])
    end

    def current_staff_group
      person.groups.find_by(name: ["admin", "super_admin"])
    end

    def active_staff?
      person.active_in_group?(current_staff_group.name)
    end

    def add_or_change_staff_role_and_group(new_group, prev_group = nil)
      person.transaction do
        person.user.change_role(prev_group, new_group)

        # Remove existing admin/super_admin groups
        person.groups.where(name: [:admin, :super_admin]).each do |group|
          person.groups.destroy(group)
        end

        person.add_group(new_group)
      end
    end
  end
end
