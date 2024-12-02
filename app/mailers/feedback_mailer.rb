# Sends mail to the app developers when someone submits a feedback form.

class FeedbackMailer < ApplicationMailer
  def send_feedback
    @name = params[:name]
    @email = params[:email]
    @subject = params[:subject]
    @message = params[:message]

    mail(from: Rails.application.config.from_email,
      to: Rails.application.config.from_email,
      subject: @subject)
  end
end
