class FeedbackController < ApplicationController
  include OrganizationScopable

  skip_before_action :authenticate_user!
  skip_verify_authorized only: %i[new create show]
  layout :set_layout, only: %i[new]

  def show
  end

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.valid?
      FeedbackMailer.with(feedback_params).send_message.deliver_later
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

  def feedback_params
    params.require(:feedback).permit(:name, :email, :message, :subject)
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
