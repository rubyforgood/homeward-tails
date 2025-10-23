module Organizations
  class AccountsController < Organizations::BaseController
    include DashboardContextable
    before_action :set_person, only: %i[show]

    def show
      authorize! @person, with: AccountPolicy
    end

    private

    def set_person
      @person = Person.find(params[:id])
    end
  end
end
