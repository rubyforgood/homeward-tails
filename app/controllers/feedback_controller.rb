class FeedbackController < ApplicationController
  include OrganizationScopable

  skip_before_action :authenticate_user!
  skip_before_action :verify_and_set_current_person
  skip_verify_authorized only: %i[new create]
  layout :set_layout, only: %i[new]

  def new
    @feedback = Feedback.new
    @feedback.email = current_user.email if current_user.present?
  end

  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.valid?
      FeedbackMailer.with(feedback_params).send_feedback.deliver_now
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

  def path
    if current_user.nil?
      root_path
    elsif current_user.has_role?(:adopter, ActsAsTenant.current_tenant)
      adopter_fosterer_dashboard_index_path
    else
      staff_dashboard_index_path
    end
  end
end
