class ActiveStorage::AttachmentPolicy < ApplicationPolicy
  pre_check :verify_organization!
  pre_check :verify_active_staff!, only: [:purge?]

  def purge?
    permission?(:purge_attachments)
  end

  def purge_avatar?
    permission?(:purge_avatar)
  end

  private

  def organization
    @organization || record_organization
  end

  # `record` should be an ActiveStorage Attachment which responds to `#record`.
  def record_organization
    if record.record.is_a?(Organization)
      record.record
    else
      record.record.organization
    end
  end
end
