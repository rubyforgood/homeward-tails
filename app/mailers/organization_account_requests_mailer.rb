class OrganizationAccountRequestsMailer < ApplicationMailer
  def create_new_organization_account_request
    @organization_name = params[:name]
    @requester_name = params[:requester_name]
    @organization_phone = params[:phone_number]
    @organization_email = params[:email]
    @country = params[:country]
    @city_town = params[:city_town]
    @province_state = params[:province_state]

    mail(from: "default@petrescue.org",
      to: "devs@email.com",
      subject: "New Organization Account Request")
  end
end
