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
        import = Organizations::Importers::CsvImportService.new(params[:files]).call
        render turbo_stream: turbo_stream.replace("results", partial: "organizations/staff/external_form_upload/upload_results", locals: {import: import})
      end
    end
  end
end
