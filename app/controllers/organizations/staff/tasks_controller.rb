class Organizations::Staff::TasksController < Organizations::BaseController
  before_action :set_pet, only: %i[new show index create edit update destroy]
  before_action :set_task, only: %i[show edit update destroy]

  def new
    authorize! Task, context: {pet: @pet}

    @task = @pet.tasks.build
  end

  def index
    authorize! Task, context: {pet: @pet}

    if params[:cancel] == "true"
      respond_to do |format|
        format.html
        format.turbo_stream { render turbo_stream: turbo_stream.update("new_task", "") }
      end
    end

    @tasks = @pet.tasks.list_ordered
  end

  def show
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    authorize! Task, context: {pet: @pet}

    @task = @pet.tasks.build(task_params)

    if @task.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("tasks_pet_#{@pet.id}", partial: "organizations/staff/pets/tabs/tasks", locals: {task: @task}) }
        format.html { redirect_to staff_pet_url(@pet, active_tab: "tasks") }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@task, partial: "organizations/staff/tasks/form", locals: {task: @task, url: staff_pet_tasks_path(@task.pet)}), status: :bad_request }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    @task.next_due_date_in_days = nil unless task_params.dig(:next_due_date_in_days) || task_params.dig(:completed)

    respond_to do |format|
      if @task.update(task_params)
        if @task.recurring && @task.completed_previously_changed?(from: false, to: true)
          Organizations::TaskService.new(@task).create_next
        end

        format.turbo_stream { render turbo_stream: turbo_stream.replace("tasks_pet_#{@pet.id}", partial: "organizations/staff/pets/tabs/tasks", locals: {task: @task}) }
        format.html { redirect_to staff_pet_url(@pet, active_tab: "tasks") }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@task, partial: "organizations/staff/tasks/form", locals: {task: @task, url: staff_pet_task_path(@task.pet)}), status: :bad_request }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to staff_pet_path(@pet), notice: t(".success") }
      format.turbo_stream
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to staff_pets_path
  end

  private

  def set_pet
    @organization = Current.organization
    raise ActiveRecord::RecordNotFound if @organization.nil?

    @pet = @organization.pets.find(params[:pet_id] || params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to staff_pets_path unless @pet
  end

  def set_task
    @task = Task.find(params[:id])
    authorize! @task
  rescue ActiveRecord::RecordNotFound
    redirect_to staff_pets_path
  end

  def task_params
    params.require(:task).permit(:name, :description, :completed, :due_date, :recurring, :next_due_date_in_days)
  end
end
