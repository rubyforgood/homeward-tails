class OrganizationAccountRequestsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_verify_authorized

  def new
    @organization_acccount_request = Organization.new
  end

  def create
    @organization_acccount_request = Organization.new(organization_params)

    if @organization_acccount_request.valid?
      OrganizationAccountRequestsMailer.with(organization_params)
        .create_new_organization_account_request.deliver_now

      redirect_to root_path, notice: I18n.t("contacts.create.success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def organization_params
    params.require(:organization).permit(
      :name,
      :slug,
      :requester_name,
      :phone_number,
      :email,
      locations_attributes: %i[id city_town country province_state]
    )
  end
end
