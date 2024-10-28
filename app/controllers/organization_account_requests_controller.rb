class OrganizationAccountRequestsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_verify_authorized

  def new
    @organization_acccount_request = Organization.new
  end

  def create
    @organization_acccount_request = Organization.new(organization_params)

    if @organization_acccount_request.save
      # OrganizationAccountRequestMailer.with(contact_params).send_message.deliver_later
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
      :organization_requester_name,
      :phone_number,
      :email,
      location_attributes: %i[id city_town country province_state]
    )
  end
end

