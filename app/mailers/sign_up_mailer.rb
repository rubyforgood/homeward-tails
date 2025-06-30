class SignUpMailer < ApplicationMailer
  def adopter_welcome_email
    @person = params[:person] || @user.people.first
    @organization = params[:organization]
  end
end
