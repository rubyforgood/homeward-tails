class FeedbackController < ApplicationController
  include OrganizationScopable

  skip_before_action :authenticate_user!
  skip_verify_authorized only: %i[new create show]
  layout :set_layout, only: %i[new]

  def show
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.valid?
      FeedbackMailer.with(contact_params).send_message.deliver_later
      path = case set_layout
      when "adopter_foster_dashboard"
        adopter_fosterer_dashboard_index_path
      when "dashboard"
        staff_dashboard_index_path
      else
        root_path
      end
      redirect_to path, notice: I18n.t("contacts.create.success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message, :subject)
  end

  def set_layout
    if current_user.nil?
      "application"
    elsif current_user.has_role?(:adopter, ActsAsTenant.current_tenant)
      "adopter_foster_dashboard"
    else
      "dashboard"
    end
  end
end
