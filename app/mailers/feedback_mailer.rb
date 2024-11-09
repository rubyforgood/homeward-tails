class FeedbackMailer < ApplicationMailer
  def send_message
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]

    mail to: "devs@email.com", subject: "New Support Message"
  end
end
