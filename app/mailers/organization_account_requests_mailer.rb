# Sends mail to app developers when someone submits the organization account request form.

class OrganizationAccountRequestsMailer < ApplicationMailer
  def new_organization_account_request
    @organization_name = params[:name]
    @requester_name = params[:requester_name]
    @organization_phone = params[:phone_number]
    @organization_email = params[:email]
    @country = params[:country]
    @city_town = params[:city_town]
    @province_state = params[:province_state]

    mail(to: Rails.application.config.from_email, subject: "New Organization Account Request")
  end
end
