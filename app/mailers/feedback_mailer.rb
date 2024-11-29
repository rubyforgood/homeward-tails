class FeedbackMailer < ApplicationMailer
  def send_message
    @name = params[:name]
    @email = params[:email]
    @subject = params[:subject]
    @message = params[:message]

    mail(from: Rails.application.config.from_email,
         to: Rails.application.config.from_email,
         subject: @subject)
  end
end
