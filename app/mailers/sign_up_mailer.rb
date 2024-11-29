class SignUpMailer < ApplicationMailer
  def adopter_welcome_email(tenant_org)
    @user = params[:user]
    @home_url = "https://www.bajapetrescue.com"
    @faq_url = "https://www.bajapetrescue.com/faq"
    mail(from: Rails.application.config.from_email,
      to: @user.email,
      subject: "Welcome to Baja Pet Rescue")
  end

  def staff_welcome_email(tenant_org)
    @user = params[:user]
    @home_url = "https://www.bajapetrescue.com"
    @faq_url = "https://www.bajapetrescue.com/faq"
    mail(from: Rails.application.config.from_email,
      to: @user.email,
      subject: "Welcome to Baja Pet Rescue")
  end

  def admin_notification_new_staff(tenant_org)
    @home_url = "https://www.bajapetrescue.com"
    @faq_url = "https://www.bajapetrescue.com/faq"
    @user = params[:user]
    mail(from: Rails.application.config.from_email,
      to: "wcrwater@gmail.com",
      subject: "New Staff Account")
  end
end
