module Organizations
  class ActivationsController < Organizations::BaseController
    def update
      @user = User.find(params[:user_id])

      authorize! @user, with: ActivationsPolicy

      if @user.deactivated_at
        @user.activate
      else
        @user.deactivate
      end

      respond_to do |format|
        success = @user.deactivated_at.nil? ?
          t(".activated", staff: @user.full_name) :
          t(".deactivated", staff: @user.full_name)
        format.html { redirect_to staff_staff_index_path, notice: success }
        format.turbo_stream { flash.now[:notice] = success }
      end
    end
  end
end
