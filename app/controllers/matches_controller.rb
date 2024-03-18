class MatchesController < ApplicationController
  before_action :set_pet, only: %i[create]
  before_action :set_match, only: %i[destroy]

  def create
    authorize! context: {organization: @pet.organization}

    @match = Match.new(match_params.merge(
      organization_id: @pet.organization_id
    ))

    if @match.save
      @match.retire_applications

      redirect_back_or_to dashboard_index_path, notice: "Pet successfully adopted."
    else
      redirect_back_or_to dashboard_index_path, alert: "Error."
    end
  end

  def destroy
    if @match.destroy
      @match.withdraw_application

      redirect_to pets_path, notice: "Adoption reverted & application set to 'Withdrawn'"
    else
      redirect_to pets_path, alert: "Failed to revert adoption"
    end
  end

  private

  def match_params
    params.require(:match).permit(:pet_id, :adopter_foster_account_id)
  end

  def set_pet
    @pet = Pet.find(match_params[:pet_id])
  end

  def set_match
    @match = Match.find(params[:id])
    authorize! @match
  end
end
