class Organizations::Staff::UserRolesController < Organizations::BaseController
  before_action :set_user

  def to_staff
    if @user.change_role(:admin, :staff)
      respond_to do |format|
        format.html { redirect_to request.referrer, notice: t(".success") }
        format.turbo_stream { flash.now[:notice] = t(".success") }
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referrer, alert: t(".error") }
        format.turbo_stream { flash.now[:alert] = t(".error") }
      end
    end
  end

  def to_admin
    if @user.change_role(:staff, :admin)
      respond_to do |format|
        format.html { redirect_to request.referrer, notice: t(".success") }
        format.turbo_stream { flash.now[:notice] = t(".success") }
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referrer, alert: t(".error") }
        format.turbo_stream { flash.now[:alert] = t(".error") }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize! @user, with: Organizations::UserRolesPolicy, to: :change_role?,
      context: {organization: Current.organization}
  end
end
