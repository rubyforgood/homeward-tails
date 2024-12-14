module Organizations
  module AdopterFosterer
    class FormSubmissionPolicy < ApplicationPolicy
      pre_check :verify_organization!

      def index?
        permission?(:view_latest_form_submission) && form_submission_belongs_to_user
      end

      private

      def form_submission_belongs_to_user
        latest_form_submission.person_id == user.person_id
      end
    end
  end
end
