class SignUpMailer < ApplicationMailer
  def adopter_welcome_email(current_tenant)
    @organization = current_tenant
    @user = params[:user]

    mail(to: @user.email, subject: "No Reply: Welcome to #{@organization.name}")
  end
end
