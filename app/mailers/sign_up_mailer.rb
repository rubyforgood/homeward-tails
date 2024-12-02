class SignUpMailer < ApplicationMailer
  def adopter_welcome_email(current_tenant)
    @organization = current_tenant
    @user = params[:user]
    @home_url = "https://www.homewardtails.org/#{@organization.slug}"
    @faq_url = "https://www.homewardtails.org/#{@organization.slug}/faq"

    mail(from: Rails.application.config.from_email,
         to: @user.email,
         subject: "Welcome to #{@organization.name}")
  end
end
