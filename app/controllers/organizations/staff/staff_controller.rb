class Organizations::Staff::StaffController < Organizations::BaseController
  include ::Pagy::Backend

  layout "dashboard"

  def index
    authorize! User, context: {organization: Current.organization}

    @pagy, @staff = pagy(User.staff, limit: 10)
  end
end
