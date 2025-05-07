module Organizations
  module Staff
    class UserRolesController < Organizations::BaseController
      before_action :set_person

      def to_admin
        @person.staff_change_group(:admin)
        if @person.active_in_group?(:admin)
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
        @person.staff_change_group(:super_admin)
        if @person.active_in_group?(:super_admin)

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

      def set_person
        @person = Person.find(params[:id])
        authorize! @person, with: Organizations::UserRolesPolicy, to: :change_role?
      end
    end
  end
end
