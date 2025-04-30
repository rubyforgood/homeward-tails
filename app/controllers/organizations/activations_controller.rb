module Organizations
  class ActivationsController < Organizations::BaseController
    before_action :set_pg

    def update
      @result = if params[:person_group][:deactivated] == "true"
        [@person.deactivate!(@group), t(".deactivated", staff: @person.full_name)]
      elsif params[:person_group][:deactivated] == "false"
        [@person.activate!(@group), t(".activated", staff: @person.full_name)]
      else
        ["invalid parameter"]
      end

      if @result[0] == true
        respond_to do |format|
          format.html { redirect_to staff_staff_index_path, notice: @result[1] }
          format.turbo_stream { flash.now[:notice] = @result[1] }
        end
      else
        respond_to do |format|
          format.html { redirect_back_or_to staff_staff_index_path, alert: @result[0] }
          format.turbo_stream { flash.now[:alert] = @result[0] }
        end
      end
    end

    private

    def set_pg
      @pg = PersonGroup.find(params[:id])
      @person = Person.find(@pg.person_id)
      @group = @pg.group

      authorize! @person, with: ActivationsPolicy, context: {group: @group}
    end
  end
end
