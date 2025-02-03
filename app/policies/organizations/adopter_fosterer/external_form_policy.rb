module Organizations
  module AdopterFosterer
    class ExternalFormPolicy < Organizations::ApplicationPolicy
      def index?
        permission?(:view_external_form)
      end
    end
  end
end
