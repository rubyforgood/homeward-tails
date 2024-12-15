module Organizations
  module AdopterFosterer
    class FormAnswersController < Organizations::BaseController
      layout "adopter_foster_dashboard"

      before_action :context_authorize!
      before_action :set_latest_form_submission

      def index
        @form_answers = authorized_scope(@latest_form_submission.form_answers)
      end

      private

      def context_authorize!
        authorize! with: Organizations::AdopterFosterer::FormAnswerPolicy
      end

      def set_latest_form_submission
        @latest_form_submission = current_user.person.latest_form_submission
      end
    end
  end
end
