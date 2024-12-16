class Organizations::Staff::FosterersController < Organizations::BaseController
  layout "dashboard"
  include ::Pagy::Backend

  before_action :authorize_user, only: %i[edit update]

  def index
    authorize! Person, context: {organization: Current.organization}

    @pagy, @fosterer_accounts = pagy(
      authorized_scope(Person.fosterers),
      limit: 10
    )
  end

  def edit
    @fosterer = Person.find(params[:id])
    @fosterer.location || @fosterer.build_location
  end

  def update
    @fosterer = Person.find(params[:id])

    if @fosterer.update(fosterer_params)
      flash[:success] = t(".success")
      redirect_to action: :index
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def fosterer_params
    params.require(:person)
      .permit(
        :first_name, :last_name, :email, :phone_number,
        location_attributes: %i[country province_state city_town id]
      )
  end

  def authorize_user
    authorize! Person, context: {organization: Current.organization},
      with: Organizations::FostererInvitationPolicy
  end
end
