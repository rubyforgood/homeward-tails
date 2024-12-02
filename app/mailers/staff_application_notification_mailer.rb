class StaffApplicationNotificationMailer < ApplicationMailer
  def new_adoption_application
    @organization_staff = params[:organization_staff]
    @pet = params[:pet]

    if @organization_staff.any?
      emails = @organization_staff.collect(&:email).join(",")

      mail(from: Rails.application.config.from_email,
           to: emails,
           subject: "New Adoption Application")
    end
  end
end
