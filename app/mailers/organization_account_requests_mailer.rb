class OrganizationAccountRequestsMailer < ApplicationMailer
  def create_new_organization_account_request
    @organization_name = params[:name]
    @requester_name = params[:organization_requester_name]
    @organization_phone = params[:phone_number]
    @organization_email = params[:email]
    @country = params[:locations][:country]
    @city_town = params[:locations][:city_town]
    @province_state = params[:locations][:province_state]

    mail(from: "default@petrescue.org",
      to: "devs@email.com",
      subject: "New Organization Account Request")
  end
end
