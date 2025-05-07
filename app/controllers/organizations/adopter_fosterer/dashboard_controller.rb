class Organizations::AdopterFosterer::DashboardController < Organizations::BaseController
  layout "adopter_foster_dashboard"

  def index
    # @user = current_user
    @organization = Current.organization
    @hide_footer = true
    @application_count = Current.person.adopter_applications.count.to_i

    @adoptable_unique_species = Pet.adoptable_unique_species

    authorize! :adopter_foster_dashboard
  end
end
