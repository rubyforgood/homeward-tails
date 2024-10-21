module Organizations
  module Staff
    class ExternalFormUploadController < Organizations::BaseController
      layout "dashboard"

      def index
        authorize! :external_form_upload,
          context: {organization: Current.organization}
      end

      def create
        authorize! :external_form_upload,
          context: {organization: Current.organization}
        file = params.require(:files).first
        import_service = Organizations::Importers::GoogleCsvImportService.new(file)
        import_service.call
      end
    end
  end
end
