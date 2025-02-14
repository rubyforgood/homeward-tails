class Organizations::Staff::FosterersController < Organizations::BaseController
  layout "dashboard"
  include ::Pagy::Backend

  before_action :authorize_user, only: %i[edit update]

  def index
    authorize! Person, context: {organization: Current.organization}

    @q = authorized_scope(Person.fosterers).ransack(params[:q])
    @pagy, @fosterer_accounts = pagy(
      @q.result,
      limit: 10
    )
    respond_to do |format|
      format.html
      format.csv { send_data @fosterer_accounts.to_csv(%w[email]), filename: "fosterer_emails-#{Date.today}.csv" }
    end
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
