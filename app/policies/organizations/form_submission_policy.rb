module Organizations
  class FormSubmissionPolicy < ApplicationPolicy
    pre_check :verify_organization!
    # pre_check :verify_active_staff!

    alias_rule :index?, to: :manage?

    def manage?
      permission?(:view_form_submissions)
    end
  end
end
