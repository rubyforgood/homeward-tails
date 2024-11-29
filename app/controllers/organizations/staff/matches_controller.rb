class Organizations::Staff::MatchesController < Organizations::BaseController
  before_action :set_pet, only: %i[create]
  before_action :set_match, only: %i[destroy]

  def create
    authorize! context: {organization: @pet.organization}

    @match = Match.new(match_params.merge(
      organization_id: @pet.organization_id
    ))

    if @match.save
      AdoptionMailer.reminder(@match).deliver_now
      @match.retire_applications

      redirect_back_or_to staff_dashboard_index_path, notice: t(".success")
    else
      redirect_back_or_to staff_dashboard_index_path, alert: t(".error")
    end
  end

  def destroy
    if @match.destroy
      @match.withdraw_application

      redirect_to staff_pets_path, notice: t(".success")
    else
      redirect_to staff_pets_path, alert: t(".error")
    end
  end

  private

  def match_params
    params.require(:match).permit(:person_id, :pet_id, :match_type, :start_date, :end_date)
  end

  def set_pet
    @pet = Pet.find(match_params[:pet_id])
  end

  def set_match
    @match = Match.find(params[:id])
    authorize! @match
  end
end
