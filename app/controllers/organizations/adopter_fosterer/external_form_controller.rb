module Organizations
  module AdopterFosterer
    class ExternalFormController < Organizations::BaseController
      layout :form_layout

      def index
        authorize! with: ExternalFormPolicy

        @form_url = Current.organization.external_form_url
      end

      private

      def form_layout
        return "adopter_foster_dashboard" if params[:dashboard]

        "application"
      end
    end
  end
end
