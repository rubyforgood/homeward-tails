# Sends mail to an organization's email address when someone submits the contact form.

class ContactsMailer < ApplicationMailer
  def send_message(current_tenant)
    @organization = current_tenant
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]

    mail(to: @organization.email, subject: "New message via Homeward Tails")
  end
end
