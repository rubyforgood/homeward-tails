module Organizations
  module CustomForm
    class FormPolicy < Organizations::ApplicationPolicy
      pre_check :verify_organization!
      pre_check :verify_active_staff!

      alias_rule :new?, :create?, :index?, to: :manage?

      def manage?
        permission?(:manage_forms)
      end
    end
  end
end
