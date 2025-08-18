module Organizations
  module Staff
    class GroupManagementsController < Organizations::BaseController
      before_action :set_person, only: %i[create update]
      before_action :set_group, only: %I[update]

      def create
        group = params[:group]&.to_sym

        authorize! @person, with: GroupManagementPolicy, context: {group: group}
        @person.add_group(group)

        redirect_to staff_people_path, notice: "#{group.to_s.titleize} group added."
      end

      def update
        success, message =
          case params[:action_type]
          when "activation"
            handle_activation
          when "group_change"
            handle_group_change
          else
            [false, "Invalid parameters"]
          end

        if success
          respond_to do |format|
            format.html { redirect_back_or_to staff_staff_index_path, notice: message }
            format.turbo_stream { flash.now[:notice] = message }
          end
        else
          respond_to do |format|
            format.html { redirect_back_or_to staff_staff_index_path, alert: message }
            format.turbo_stream { flash.now[:alert] = message }
          end
        end
      end

      private

      def set_person
        @person = Person.find(params[:person_id])
      end

      def set_group
        if params[:action_type] == "activation"
          @pg = PersonGroup.find(params[:person_group_id])
          @group = @pg.group
        else # group_change
          @group = params[:group]&.to_sym
        end

        authorize! @person, with: GroupManagementPolicy, to: :update?, context: {group: @group}
      end

      def handle_activation
        if deactivate == true
          [true, t(".deactivated", person: @person.full_name, group: @group.name.titleize)] if @person.deactivate(@group)
        elsif deactivate == false
          [true, t(".activated", person: @person.full_name, group: @group.name.titleize)] if @person.activate(@group)
        else
          [false, t(".activation_toggle_error")]
        end
      end

      def handle_group_change
        if @person.staff_change_group(@group)
          [true, t(".activated", person: @person.full_name, group: @group.name.titleize)]
        else
          [false, t(".group_change_error")]
        end
      end

      def deactivate
        ActiveModel::Type::Boolean.new.cast(params[:person_group][:deactivated])
      end
    end
  end
end
