module Organizations
  module Staff
    class ExternalFormUploadController < Organizations::BaseController
      include AttachmentManageable
      layout "dashboard"
      before_action :allow_only_one_attachment, only: [:create]
      before_action :handle_incorrect_file_format_when_csv_expected, only: [:create]

      def index
        authorize! :external_form_upload, context: {organization: Current.organization}
      end

      def create
        authorize! :external_form_upload, context: {organization: Current.organization}
        file = params[:files]

        @blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: file.original_filename)

        CsvImportJob.perform_later(@blob.signed_id, current_user.id)

        flash.now[:notice] = t(".processing_file")
        respond_to do |format|
          format.turbo_stream
        end
      end
    end
  end
end
