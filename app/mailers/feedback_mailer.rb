class FeedbackMailer < ApplicationMailer
  def send_message
    @name = params[:name]
    @email = params[:email]
    @subject = params[:subject]
    @message = params[:message]

    mail to: "devs@email.com", subject: @subject
  end
end
