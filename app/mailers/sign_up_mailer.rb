class SignUpMailer < ApplicationMailer
  def adopter_welcome_email(current_tenant)
    @user = params[:user]
    @home_url = "https://www.homewardtails.org/#{current_tenant.slug}"
    @faq_url = "https://www.homewardtails.org/#{current_tenant.slug}/faq"

    mail(from: Rails.application.config.from_email,
         to: @user.email,
         subject: "Welcome to #{current_tenant.name}")
  end
end
