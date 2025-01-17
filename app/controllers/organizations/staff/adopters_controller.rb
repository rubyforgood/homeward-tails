class Organizations::Staff::AdoptersController < Organizations::BaseController
  layout "dashboard"
  include ::Pagy::Backend

  def index
    authorize! Person, context: {organization: Current.organization}

    @q = authorized_scope(Person.adopters).ransack(params[:q])
    @pagy, @adopter_accounts = pagy(
      @q.result,
      limit: 10
    )
  end
end
