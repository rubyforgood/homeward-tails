module Organizations
  module Staff
    class FormAnswersController < Organizations::BaseController
      before_action :context_authorize!, only: %i[index]
      before_action :set_form_submission

      def index
        @form_answers = @form_submission.form_answers.order(created_at: :desc)
      end

      private

      def set_form_submission
        @form_submission = FormSubmission.find_by(id: params[:form_submission_id])
      end

      def context_authorize!
        authorize! FormAnswer,
                   context: {organization: Current.organization},
                   with: Organizations::FormSubmissionPolicy
      end
    end
  end
end
