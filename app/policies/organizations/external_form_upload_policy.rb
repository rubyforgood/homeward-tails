module Organizations
  class ExternalFormUploadPolicy < ApplicationPolicy
    pre_check :verify_organization!
    # pre_check :verify_active_staff!

    def index?
      permission?(:manage_external_form_uploads)
    end

    def create?
      permission?(:manage_external_form_uploads)
    end
  end
end
