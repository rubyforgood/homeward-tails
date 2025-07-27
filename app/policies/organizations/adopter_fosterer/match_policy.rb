module Organizations
  module AdopterFosterer
    class MatchPolicy < ApplicationPolicy
      authorize :type
      relation_scope do |relation|
        relation.where(person_id: person.id)
      end

      def index?
        if type == "foster"
          permission?(:view_foster_matches)
        elsif type == "adoption"
          permission?(:view_adopter_matches)
        end
      end
    end
  end
end
