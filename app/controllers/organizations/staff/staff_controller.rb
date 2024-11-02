class Organizations::Staff::StaffController < Organizations::BaseController
  before_action :set_staff, only: [:update_activation]
  include ::Pagy::Backend

  layout "dashboard"

  def index
    authorize! User, context: {organization: Current.organization}

    @pagy, @staff = pagy(
      authorized_scope(User.staff),
      limit: 10
    )
  end

  def update_activation
    if @staff.deactivated_at
      @staff.activate
    else
      @staff.deactivate
    end

    respond_to do |format|
      success = @staff.deactivated_at.nil? ?
        t(".activated", staff: @staff.full_name) :
        t(".deactivated", staff: @staff.full_name)
      format.html { redirect_to staff_staff_index_path, notice: success }
      format.turbo_stream { flash.now[:notice] = success }
    end
  end

  private

  def set_staff
    @staff = User.find(params[:staff_id])

    authorize! @staff
  end
end
