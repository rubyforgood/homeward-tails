class Organizations::Staff::MatchesController < Organizations::BaseController
  before_action :set_pet, only: %i[create]

  def create
    authorize!

    @match = Match.new(match_params.merge(
      organization_id: @pet.organization_id
    ))

    if @match.save
      AdoptionMailer.new_adoption(@match).deliver_later
      @match.retire_applications

      redirect_back_or_to staff_dashboard_index_path, notice: t(".success")
    else
      redirect_back_or_to staff_dashboard_index_path, alert: t(".error")
    end
  end

  private

  def match_params
    params.require(:match).permit(:person_id, :pet_id, :match_type, :start_date, :end_date)
  end

  def set_pet
    @pet = Pet.find(match_params[:pet_id])
  end
end
