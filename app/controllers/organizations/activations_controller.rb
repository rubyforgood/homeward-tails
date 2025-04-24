module Organizations
  class ActivationsController < Organizations::BaseController
    before_action :set_pg

    def update
      if params[:person_group][:deactivated] == "true"
        @pg.update!(deactivated_at: Time.now)
        @person.user.remove_role(@group.name, Current.organization)
      elsif params[:person_group][:deactivated] == "false"
        @pg.update!(deactivated_at: nil)
        @person.user.add_role(@group.name, Current.organization)
      else
        respond_to do |format|
          format.html { redirect_back_or_to staff_staff_index_path, alert: t("errors.try_again)") }
          format.turbo_stream { flash.now[:alert] = t("errors.try_again") and return }
        end
      end

      respond_to do |format|
        success = @person.active_in_group?(@group.name) ?
          t(".activated", staff: @person.full_name) :
          t(".deactivated", staff: @person.full_name)
        format.html { redirect_to staff_staff_index_path, notice: success }
        format.turbo_stream { flash.now[:notice] = success }
      end
    end

    private

    def set_pg
      @pg = PersonGroup.find(params[:id])
      @group = Group.find(@pg.group_id)
      @person = Person.find(@pg.person_id)

      authorize! @person, with: ActivationsPolicy, context: {group: @group.name}
    end
  end
end
