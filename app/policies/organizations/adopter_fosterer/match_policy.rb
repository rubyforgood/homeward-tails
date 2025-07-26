module Organizations
  module AdopterFosterer
    class MatchPolicy < ApplicationPolicy
      authorize :page
      relation_scope do |relation|
        relation.where(person_id: person.id)
      end

      def index?
        if page == "fostered_pets"
          person.active_in_group?(:fosterer) && permission?(:view_foster_adopter_matches)
        elsif page == "adopted_pets"
          person.active_in_group?(:adopter) && permission?(:view_adopter_foster_matches)
        end
      end
    end
  end
end
