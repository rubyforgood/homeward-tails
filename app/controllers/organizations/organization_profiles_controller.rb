class Organizations::OrganizationProfilesController < Organizations::BaseController
  layout "dashboard"

  def edit
    @organization_profile = OrganizationProfile.first
  end

  def update
    @organization_profile = OrganizationProfile.first
    if @organization_profile.update(organization_profile_params)
      redirect_to edit_organization_profile_path, notice: "Your profile has been updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def organization_profile_params
    params.require(:organization_profile).permit(
      :phone_number,
      :email,
      :about_us,
      :append_avatar,
      location_attributes: %i[city_town country province_state]
    )
  end
end
