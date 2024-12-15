module Organizations
  module Staff
    class FormSubmissionsController < Organizations::BaseController
      layout "dashboard"

      before_action :context_authorize!, only: %i[index]
      before_action :set_person

      def index
        @form_submissions = @person.form_submissions.order(created_at: :desc)
      end

      private

      def set_person
        @person = Person.find_by(id: params[:person_id])
      end

      def context_authorize!
        authorize! FormSubmission,
          context: {organization: Current.organization}
      end
    end
  end
end
