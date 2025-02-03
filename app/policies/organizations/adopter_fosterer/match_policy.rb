module Organizations
  module AdopterFosterer
    class MatchPolicy < Organizations::ApplicationPolicy
      relation_scope do |relation|
        relation.where(person_id: user.person.id)
      end

      def index?
        permission?(:view_adopter_foster_matches)
      end
    end
  end
end
