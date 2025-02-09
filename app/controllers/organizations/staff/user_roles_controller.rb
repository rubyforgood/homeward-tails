class Organizations::Staff::UserRolesController < Organizations::BaseController
  before_action :set_user

  def to_admin
    if @user.change_role(:super_admin, :admin)
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

  def to_super_admin
    puts "1"
    if @user.change_role(:admin, :super_admin)
      puts "2"
      respond_to do |format|
        puts "3"
        format.html { redirect_to request.referrer, notice: t(".success") }
        format.turbo_stream { flash.now[:notice] = t(".success") }
      end
    else
      puts "4"
      respond_to do |format|
        puts "5"
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
