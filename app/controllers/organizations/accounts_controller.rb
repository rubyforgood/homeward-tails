module Organizations
  class AccountsController < Organizations::BaseController
    include ::Pagy::Backend

    layout :set_layout, only: %i[show]
    before_action :set_person, only: %i[show]

    def show
      authorize! @person
    end

    private

    def set_layout
      if allowed_to?(:index?, with: Organizations::DashboardPolicy)
        "dashboard"
      elsif allowed_to?(:index?, with: Organizations::AdopterFosterDashboardPolicy)
        "adopter_foster_dashboard"
      else
        "application"
      end
    end

    def set_person
      @person = Person.find(params[:id])
    end
  end
end
