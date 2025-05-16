module Organizations
  class FormSubmissionPolicy < ApplicationPolicy
    pre_check :verify_record_organization!

    alias_rule :index?, to: :manage?

    def manage?
      permission?(:view_form_submissions)
    end
  end
end
