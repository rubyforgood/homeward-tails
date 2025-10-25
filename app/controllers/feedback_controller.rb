class FeedbackController < ApplicationController
  include OrganizationScopable
  include DashboardContextable

  skip_before_action :authenticate_user!
  skip_verify_authorized only: %i[new create]

  def new
    @feedback = Feedback.new
    @feedback.email = current_user.email if current_user.present?
  end

  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.valid?
      FeedbackMailer.with(feedback_params).send_feedback.deliver_later
      redirect_to dashboard_redirect_path, notice: I18n.t("contacts.create.success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:name, :email, :message, :subject)
  end
end
