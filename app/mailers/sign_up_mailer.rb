class SignUpMailer < ApplicationMailer
  def adopter_welcome_email(tenant_org)
    @user = params[:user]
    @home_url = "https://www.bajapetrescue.com"
    @faq_url = "https://www.bajapetrescue.com/faq"
    mail(from: Rails.application.config.from_email,
      to: @user.email,
      subject: "Welcome to Baja Pet Rescue")
  end
end
