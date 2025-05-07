class Organizations::Staff::DashboardController < Organizations::BaseController
  before_action :context_authorize!, only: %i[index pets_with_incomplete_tasks pets_with_overdue_tasks]
  before_action :set_pets_with_overdue_tasks, only: %i[index pets_with_overdue_tasks]
  before_action :set_pets_with_incomplete_tasks, only: :pets_with_incomplete_tasks
  include Pagy::Backend
  layout "dashboard"

  def index
    @user = current_user
    @organization = Current.organization
    @hide_footer = true
    @not_completed_not_overdue_tasks_count = Task.is_not_completed.not_overdue.count
    @not_completed_overdue_tasks_count = Task.is_not_completed.overdue.count

    @awaiting_review_count = Pet.filter_by_application_status("awaiting_review").count
    @under_review_count = Pet.filter_by_application_status("under_review").count

    @current_foster_count = Match.fosters.current.count
    @upcoming_foster_count = Match.fosters.upcoming.count
  end

  def pets_with_incomplete_tasks
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("tasks-frame", partial: "organizations/staff/dashboard/pets_with_incomplete_or_overdue_tasks")
      end
      format.html { render :tasks }
    end
  end

  def pets_with_overdue_tasks
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("tasks-frame", partial: "organizations/staff/dashboard/pets_with_incomplete_or_overdue_tasks")
      end
      format.html { render :tasks }
    end
  end

  private

  def context_authorize!
    authorize! :dashboard
  end

  def set_pets_with_overdue_tasks
    @pagy, @pets = pagy(Pet.with_overdue_tasks, limit: 5)
    @column_name = "Overdue Tasks"
    @header_title = "Overdue Pet Tasks"
  end

  def set_pets_with_incomplete_tasks
    @pagy, @pets = pagy(Pet.with_incomplete_tasks, limit: 5)
    @column_name = "Incomplete Tasks"
    @header_title = "Incomplete Pet Tasks"
  end
end
