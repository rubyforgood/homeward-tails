module GroupRoleManagement
  class GroupMember
    attr_reader :person

    def initialize(person)
      @person = person
    end

    def add_role_and_group(*names)
      raise StandardError, "Organization not set" unless Current.organization
      person.transaction do
        names.each do |name|
          person.user.add_role(name, Current.organization)
        end
        add_group(*names)
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

    private

    def add_group(*names)
      names.map(&:to_s).uniq.each do |name|
        next unless Group.names.key?(name)
        group = Group.find_or_create_by!(name: name)

        unless person.groups.exists?(id: group.id)
          person.person_groups.create!(group: group)
        end
      end
    end
  end
end
