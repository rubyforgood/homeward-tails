class SignUpMailer < ApplicationMailer
  def adopter_welcome_email(current_tenant)
    @organization = current_tenant
    @user = params[:user]
    @org_root = "#{@app_root_url}#{@organization.slug}"
    @faq_url = "#{@org_root}/faq"

    mail(to: @user.email, subject: "Welcome to #{@organization.name}")
  end
end
