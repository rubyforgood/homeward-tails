module AttachmentManageable
  def allow_only_one_attachment
    return unless params[:files].is_a?(Array)

    flash.now[:alert] = t(".attachment_manageable.upload_limit_exceeded")
    render turbo_stream: turbo_stream.replace("flash", partial: "layouts/shared/flash_messages")
  end
  
  def alert_for_no_images
    if params[:action] === 'attach_images' and params[:pet][:images].length > 1
      return
    elsif params[:action] === 'attach_files' and params[:pet][:files].length > 1
      return
    else
      flash.now[:alert] = t("attachment_manageable.attachment_missing")
      render turbo_stream: turbo_stream.replace("flash", partial: "layouts/shared/flash_messages")
    end
  end
end
