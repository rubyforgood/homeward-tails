class Organizations::Staff::DefaultPetTasksController < Organizations::BaseController
  before_action :set_task, only: %i[edit update destroy]
  before_action :ensure_due_in_days_in_q_params, only: :index
  include ::Pagy::Backend

  layout "dashboard"

  def index
    authorize!
    tasks = authorized_scope(DefaultPetTask.all)

    @q = DefaultPetTask.ransackable_tasks(tasks, params)
    @default_pet_tasks = @q.result

    @pagy, @default_pet_tasks = pagy(@default_pet_tasks, limit: 10)
  end

  def new
    authorize!
    @task = DefaultPetTask.new
  end

  def create
    authorize!
    @task = DefaultPetTask.new(task_params)

    if @task.save
      redirect_to staff_default_pet_tasks_path, notice: t(".success")
    else
      flash.now[:alert] = t(".error")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to staff_default_pet_tasks_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy

    redirect_to staff_default_pet_tasks_path, notice: t(".success")
  end

  private

  def task_params
    params.require(:default_pet_task).permit(:name, :description, :due_in_days, :species, :recurring)
  end

  def set_task
    @task = DefaultPetTask.find(params[:id])

    authorize! @task
  rescue ActiveRecord::RecordNotFound
    redirect_to staff_default_pet_tasks_path, alert: t(".error")
  end

  def ensure_due_in_days_in_q_params
    if params[:due_in_days_eq].present?
      params[:q] ||= {}
      params[:q]["due_in_days_eq"] = params[:due_in_days_eq]
    end
  end
end
