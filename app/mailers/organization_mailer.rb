# Sends email to organization representative when developers create a new organization.

class OrganizationMailer < ApplicationMailer
  def create_new_org_and_admin
    @organization = params[:organization]
    @user = params[:user]

    mail(to: @user.email, subject: "Welcome to Homeward Tails")
  end
end
