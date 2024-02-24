class AdopterApplicationsController < ApplicationController
  before_action :authenticate_user!, :adopter_with_profile
  before_action :check_pet_app_status, only: [:create]

  def index
    @applications = AdopterApplication.where(adopter_account_id:
                                             current_user.adopter_account.id)
  end

  # add check if application already exists
  def create
    @application = AdopterApplication.new(application_params)

    if @application.save
      redirect_to adoptable_pet_path(@application.pet),
        notice: "Application submitted! #{MessagesHelper.affirmations.sample}"

      # mailer
      @pet = @application.pet
      @org_staff = User.organization_staff(@pet.organization_id)
      StaffApplicationNotificationMailer.with(pet: @pet,
        organization_staff: @org_staff)
        .new_adoption_application.deliver_now
    else
      redirect_to adoptable_pet_path(@application.pet),
        alert: "Error. Please try again."
    end
  end

  # update :status to 'withdrawn' or :profile_show to false
  def update
    @application = AdopterApplication.find(params[:id])

    if @application.update(application_params)
      redirect_to adopter_applications_path
    else
      redirect_to profile_path, alert: "Error."
    end
  end

  private

  def application_params
    params.require(:adopter_application).permit(
      :pet_id,
      :adopter_account_id,
      :status,
      :profile_show
    )
  end

  def check_pet_app_status
    pet = Pet.find(params[:adopter_application][:pet_id])

    return if pet.application_paused == false

    redirect_to adoptable_pet_path(params[:adopter_application][:pet_id]),
      alert: "Applications are paused for this pet"
  end
end
