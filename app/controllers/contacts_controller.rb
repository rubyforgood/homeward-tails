class ContactsController < ApplicationController
  skip_verify_authorized only: %i[new create]

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contacts_params)

    if @contact.valid?
      ContactsMailer.with(contacts_params)
        .send_message(Current.organization.slug).deliver_now
      redirect_to root_path, notice: "Message sent!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contacts_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
