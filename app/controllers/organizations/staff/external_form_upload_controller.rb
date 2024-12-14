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

        # Only processes single file upload
        import = Organizations::Importers::CsvImportService.new(params[:files]).call

        if import.success?
          # do something
        else
          # import.errors
        end
      end
    end
  end
end
