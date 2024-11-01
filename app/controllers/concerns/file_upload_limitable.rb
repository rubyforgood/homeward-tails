module FileUploadLimitable
  extend ActiveSupport::Concern

  included do
    before_action :single_file_upload_limit, only: [:create]
  end

  private

  def single_file_upload_limit
    return unless params[:files].is_a?(Array)

    flash.now[:alert] = t(".upload_limit_exceed")
    render turbo_stream: turbo_stream.replace("flash", partial: "layouts/shared/flash_messages")
  end
end
