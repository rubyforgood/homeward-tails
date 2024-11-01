class Organizations::Staff::AdoptersController < Organizations::BaseController
  layout "dashboard"
  include ::Pagy::Backend

  def index
    authorize! Person, context: {organization:Current.organization}

    @pagy, @adopter_accounts = pagy(
      authorized_scope(Person.adopters),
      limit: 10
    )
  end
end
