module Organizations
  module AdopterFosterer
    class FormSubmissionPolicy < ApplicationPolicy
      pre_check :verify_organization!

      def index?
        return true if record.nil?

        permission?(:view_latest_form_submission) && latest_form_submission.person_id == user.id
      end
    end
  end
end