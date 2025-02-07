module Organizations
  module AdopterFosterer
    class ExternalFormPolicy < ApplicationPolicy
      def index?
        permission?(:view_external_form)
      end
    end
  end
end
