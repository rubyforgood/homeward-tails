class SignUpMailer < ApplicationMailer
  def adopter_welcome_email
    @person = params[:person]
    @organization = @person.organization

    mail(to: @person.email, subject: "No Reply: Welcome to #{@organization.name}")
  end
end
