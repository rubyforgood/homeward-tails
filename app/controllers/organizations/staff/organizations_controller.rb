module Organizations
  module Staff
    class OrganizationsController < Organizations::BaseController
      layout "dashboard"

      before_action :set_organization, only: %i[edit update]

      def edit
        @location = @organization.locations.last || @organization.locations.build # polymorphic
      end

      def update
        if @organization.update(organization_params)
          redirect_to edit_staff_organization_path, notice: t(".success")
        else
          render :edit, status: :unprocessable_entity
        end
      end

      private

      def organization_params
        params.require(:organization).permit(
          :phone_number,
          :email,
          :avatar,
          :facebook_url,
          :instagram_url,
          :donation_url,
          :external_form_url,
          locations_attributes: %i[id city_town country province_state]
        )
      end

      def set_organization
        @organization = Current.organization

        authorize! @organization
      end
    end
  end
end
