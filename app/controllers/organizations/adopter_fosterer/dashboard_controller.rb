class Organizations::AdopterFosterer::DashboardController < Organizations::BaseController
  include DashboardContextable

  before_action -> { session[:dashboard_context] = "adopter_foster_dashboard" }
  layout "adopter_foster_dashboard"

  def index
    @hide_footer = true
    @application_count = Current.person.adopter_applications.count.to_i

    @adoptable_unique_species = Pet.adoptable_unique_species

    authorize! :adopter_foster_dashboard
  end
end
