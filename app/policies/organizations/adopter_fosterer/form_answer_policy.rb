module Organizations
  module AdopterFosterer
    class FormAnswerPolicy < ApplicationPolicy
      relation_scope do |relation|
        relation.joins(form_submission: :person).where(form_submissions: { person_id: user.person.id })
      end

      def index?
       permission?(:view_form_answers)
      end
    end
  end
end
