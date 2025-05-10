module Organizations
  module Staff
    class StaffController < Organizations::BaseController
      include ::Pagy::Backend

      layout "dashboard"

      def index
        authorize! Staff

        @pagy, @staff = pagy(Person.staff.includes(person_groups: :group), limit: 10)
      end
    end
  end
end
