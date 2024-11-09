class FeedbackController < ApplicationController
  skip_before_action :authenticate_user!
  skip_verify_authorized only: %i[new create]
  layout :set_layout, only: %i[new create]

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.valid?
      FeedbackMailer.with(contact_params).send_message.deliver_later
      redirect_to root_path, notice: I18n.t("contacts.create.success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end

  def set_layout
    if current_user.nil?
      "application"
    elsif current_user.staff_account
      "dashboard"
    else
      "adopter_foster_dashboard"
    end
  end
end
