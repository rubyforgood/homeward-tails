module Organizations
  class FormSubmissionPolicy < ApplicationPolicy
    alias_rule :index?, to: :manage?

    def manage?
      permission?(:view_form_submissions)
    end
  end
end
