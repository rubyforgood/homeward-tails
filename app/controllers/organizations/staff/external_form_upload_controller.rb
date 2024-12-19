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

        CsvImportJob.set(wait: 1.second).perform_later(@blob.signed_id, Current.organization.id)

        flash.now[:notice] = t(".processing_file")
        respond_to do |format|
          format.turbo_stream
        end
      end
    end
  end
end
