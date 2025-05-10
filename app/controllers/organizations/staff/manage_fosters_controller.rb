class Organizations::Staff::ManageFostersController < Organizations::BaseController
  include ::Pagy::Backend

  layout "dashboard"

  before_action :context_authorize, only: %i[new create index]
  before_action :set_foster, only: %i[edit update destroy]

  def new
    @pets = Pet.fosterable.order(:name)
    @fosterers = Person.fosterers.order(:last_name)
    @foster = Match.new
  end

  def create
    @foster = Match.new(match_params.merge(match_type: :foster))

    if @foster.save
      FosterMailer.new_foster(@foster).deliver_now
      flash[:success] = t(".success", name: @foster.pet.name)
      redirect_to action: :index
    else
      @pets = Pet.fosterable.order(:name)
      @fosterers = Person.fosterers.order(:last_name)

      render :new, status: :unprocessable_entity
    end
  end

  def index
    @q = authorized_scope(Match.fosters).joins(:pet).ransack(params[:q])
    @pagy, paginated_fosters = pagy(
      @q.result
        .includes(:pet, :person)
        .ordered_by_status_and_date,
      limit: 10
    )
    @foster_pets = paginated_fosters.group_by(&:pet)
  end

  def edit
    # Turbo frames are an HTML mime-type
    if turbo_frame_request?
      case turbo_frame_request_id
      when helpers.dom_id(@foster, :start_date)
        render partial: "date_edit", locals: {attribute: :start_date}
      when helpers.dom_id(@foster, :end_date)
        render partial: "date_edit", locals: {attribute: :end_date}
      end
    else
      render :edit
    end
  end

  def update
    if @foster.update(match_params)
      flash[:success] = t(".success", name: @foster.pet.name)
      redirect_to action: :index
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @foster.destroy
    flash[:success] = "Foster for #{@foster.pet.name} deleted."
    redirect_to request.referer
  end

  private

  def match_params
    params.require(:match).permit(
      :pet_id,
      :person_id,
      :start_date,
      :end_date
    )
  end

  def context_authorize
    authorize! Match
  end

  def set_foster
    @foster = Match.find(params[:id])

    authorize! @foster
  end
end
