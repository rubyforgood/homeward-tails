class Organizations::AdopterFosterer::DashboardController < Organizations::BaseController
  before_action :set_adopter_fosterer_context
  layout "adopter_foster_dashboard"

  def index
    @hide_footer = true
    @application_count = Current.person.adopter_applications.count.to_i

    @adoptable_unique_species = Pet.adoptable_unique_species

    authorize! :adopter_foster_dashboard
  end

  private

  def set_adopter_fosterer_context
    session[:dashboard_context] = "adopter_foster_dashboard"
  end
end
