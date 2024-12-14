module Organizations
  module AdopterFosterer
    class FormAnswersController < Organizations::BaseController
      layout "adopter_foster_dashboard"

      before_action :set_latest_form_submission
      before_action :context_authorize!

      def index
        @form_answers = @latest_form_submission.form_answers
      end

      private

      def context_authorize!
        authorize! context: {latest_form_submission: @latest_form_submission},
                   with: Organizations::AdopterFosterer::FormSubmissionPolicy
      end

      def set_latest_form_submission
        @latest_form_submission = current_user.person.latest_form_submission
      end
    end
  end
end
