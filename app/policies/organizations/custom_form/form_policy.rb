module Organizations
  module CustomForm
    class FormPolicy < ApplicationPolicy
      pre_check :verify_record_organization!

      alias_rule :new?, :create?, :index?, to: :manage?

      def manage?
        permission?(:manage_forms)
      end
    end
  end
end
