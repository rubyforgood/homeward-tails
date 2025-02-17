module Organizations
  module AdopterFosterer
    class MatchPolicy < ApplicationPolicy
      relation_scope do |relation|
        relation.where(person_id: Person.where(user_id: user.id).first)
      end

      def index?
        permission?(:view_adopter_foster_matches)
      end
    end
  end
end
