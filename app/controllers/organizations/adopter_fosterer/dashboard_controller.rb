class Organizations::AdopterFosterer::DashboardController < Organizations::BaseController
  layout "adopter_foster_dashboard"

  def index
    @user = current_user
    @organization = Current.organization
    @hide_footer = true
    @submission_count = @user.adopter_foster_account&.submissions&.count.to_i

    authorize! :adopter_foster_dashboard, context: {organization: @organization}
  end
end
