module AttachmentManageable
  def allow_only_one_attachment
    return unless params[:files].is_a?(Array)

    flash.now[:alert] = t(".upload_limit_exceed")
    render turbo_stream: turbo_stream.replace("flash", partial: "layouts/shared/flash_messages")
  end
end
