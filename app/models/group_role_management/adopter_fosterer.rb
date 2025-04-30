module GroupRoleManagement
  class AdopterFosterer
    attr_reader :person

    def initialize(person)
      @person = person
    end

    def add_role_and_group(*names)
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
  end
end
