class Organizations::Staff::StaffController < Organizations::BaseController
  before_action :set_staff_account, only: [:deactivate, :activate, :update_activation]

  layout "dashboard"

  def index
    authorize! User, context: {organization: Current.organization}

    @staff = authorized_scope(User.joins(:roles).where(roles: {name: %i[admin super_admin]}))
  end

  def deactivate
    @staff_account.deactivate
    respond_to do |format|
      format.html { redirect_to staff_staff_index_path, notice: t(".success") }
      format.turbo_stream { render "organizations/staff/staff/update" }
    end
  end

  def activate
    @staff_account.activate
    respond_to do |format|
      format.html { redirect_to staff_staff_index_path, notice: t(".success") }
      format.turbo_stream { render "organizations/staff/staff/update" }
    end
  end

  def update_activation
    if @staff_account.deactivated_at
      activate
    else
      deactivate
    end
  end

  private

  def set_staff_account
    @staff_account = StaffAccount.find(params[:staff_id])

    authorize! @staff_account
  end
end
