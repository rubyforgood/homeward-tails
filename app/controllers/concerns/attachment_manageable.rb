module AttachmentManageable
  def allow_only_one_attachment
    return unless params[:files].is_a?(Array)

    flash.now[:alert] = t(".attachment_manageable.upload_limit_exceeded")
    render turbo_stream: turbo_stream.replace("flash", partial: "layouts/shared/flash_messages")
  end
end
