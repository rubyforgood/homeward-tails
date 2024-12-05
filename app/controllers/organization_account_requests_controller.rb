class OrganizationAccountRequestsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_verify_authorized

  def new
    @organization_account_request = OrganizationAccountRequest.new
  end

  def create
    @organization_account_request = OrganizationAccountRequest.new(organization_account_request_params)

    if @organization_account_request.valid?
      OrganizationAccountRequestsMailer.with(organization_account_request_params)
        .new_organization_account_request.deliver_now

      redirect_to root_path, notice: I18n.t("contacts.create.success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def organization_account_request_params
    params.require(:organization_account_request).permit(
      :name,
      :requester_name,
      :phone_number,
      :email,
      :city_town,
      :country,
      :province_state
    )
  end
end
