module Organizations
  class ExternalFormUploadPolicy < ApplicationPolicy
    def index?
      permission?(:manage_external_form_uploads)
    end

    def create?
      permission?(:manage_external_form_uploads)
    end
  end
end
