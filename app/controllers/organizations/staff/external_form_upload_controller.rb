module Organizations
  module Staff
    class ExternalFormUploadController < Organizations::BaseController
      include AttachmentManageable
      layout "dashboard"
      before_action :allow_only_one_attachment, only: [:create]

      def index
        authorize! :external_form_upload, context: {organization: Current.organization}
      end

      def create
        authorize! :external_form_upload, context: {organization: Current.organization}

        # TODO: Handle when we try to upload a non-CSV file.

        # Only processes single file upload
        import = Organizations::Importers::GoogleCsvImportService.new(params[:files]).call

        if import.success?
          render turbo_stream: turbo_stream.update("success", partial: "organizations/staff/external_form_upload/success_message", locals: { errors: "test" })
        else
          render turbo_stream: turbo_stream.update("errors", partial: "organizations/staff/external_form_upload/error_message", locals: { errors: "test" })
        end
      end
    end
  end
end
