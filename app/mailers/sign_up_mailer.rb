class SignUpMailer < ApplicationMailer
  def adopter_welcome_email
    @user = params[:user]
    @person = params[:person] || @user.people.first
    @organization = params[:organization]
    @org_root = root_url(script_name: "/#{@organization.slug}")

    with_organization_path do
      mail(to: @user.email, subject: "No Reply: Welcome to #{@organization.name}")
    end
  end
end
