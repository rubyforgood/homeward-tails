class Organizations::AdopterFosterDashboardController < Organizations::BaseController
  layout "adopter_foster_dashboard"

  def index
    @user = current_user
    @organization = Current.organization
    @hide_footer = true

    authorize! :adopter_foster_dashboard, context: {organization: @organization}
  end
end
