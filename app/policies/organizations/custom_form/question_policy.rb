module Organizations
  module CustomForm
    class QuestionPolicy < ApplicationPolicy
      pre_check :verify_record_organization!

      alias_rule :new?, :create?, :index?, to: :manage?

      def manage?
        permission?(:manage_questions)
      end
    end
  end
end
