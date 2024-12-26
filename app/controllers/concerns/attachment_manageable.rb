module AttachmentManageable
  def allow_only_one_attachment
    return unless params[:files].is_a?(Array)

    flash.now[:alert] = t("attachment_manageable.upload_limit_exceeded")
    render turbo_stream: turbo_stream.replace("flash", partial: "layouts/shared/flash_messages")
  end

  def show_alert_if_attachment_missing
    # images and files are arrays that sometimes populated with empty strings, so we want to remove
    # those empty strings before checking whether or no "real" images / files are being attached
    if params[:pet][:images].present?
      images = params[:pet][:images].reject { |image| image == "" }
    elsif params[:pet][:files].present?
      files = params[:pet][:files].reject { |file| file == "" }
    end

    if params[:action] == "attach_images" && images.length >= 1
      nil
    elsif params[:action] == "attach_files" && files.length >= 1
      nil
    else
      flash.now[:alert] = t("attachment_manageable.attachment_missing")
      render turbo_stream: turbo_stream.replace("flash", partial: "layouts/shared/flash_messages")
    end
  end
end
