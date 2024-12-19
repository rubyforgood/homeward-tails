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
        file = params[:files]
        @blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: file.original_filename)
        CsvImportJob.perform_later(@blob.signed_id, current_user.id, Current.organization.id)
        flash.now[:notice] = "Processing File"
        respond_to do |format|
          format.turbo_stream
        end

        # import = Organizations::Importers::CsvImportService.new(@blob, Current.organization).call
        # render turbo_stream: turbo_stream.replace("results", partial: "organizations/staff/external_form_upload/upload_results", locals: {import: import})
      end
    end
  end
end
