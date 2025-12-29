# Sends email to organization super admin for creating password

class OrganizationSetupMailer < ApplicationMailer
  def invite_super_admin
    @organization = params[:organization]
    @user = params[:user]

    # Generate the invitation token without sending Devise's default email
    @token, raw_token = Devise.token_generator.generate(User, :invitation_token)
    @user.invitation_token = @token
    @user.invitation_created_at = Time.now.utc
    @user.invitation_sent_at = Time.now.utc

    unless @user.save(validate: false)
      raise "Failed to save invitation token for user #{@user.email}"
    end

    @token = raw_token

    mail(to: @user.email, subject: "Welcome to Homeward Tails - Set Up Your Account")
  end
end
