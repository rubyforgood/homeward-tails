class OrganizationMailer < ApplicationMailer
  def create_new_org_and_admin(tenant_org)
    @organization = params[:organization]
    @user = params[:user]
    mail(from: Rails.application.config.from_email,
      to: @user.email,
      subject: "Pet Rescue - New Organization Sign Up")
  end
end
