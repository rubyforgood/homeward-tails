class ContactsMailer < ApplicationMailer
  def send_message(tenant_org)
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]
    @url = root_url
    @org_name = tenant_org

    mail(from: Rails.application.config.from_email,
      to: Rails.application.config.from_email,
      subject: "New Message via Website")
  end
end
