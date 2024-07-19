module Organizations
  module Staff
    class OrganizationsController < Organizations::BaseController
      layout "dashboard"

      before_action :set_organization, only: %i[edit update]

      def edit
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
          locations_attributes: %i[city_town country province_state]
        )
      end

      def set_organization
        @organization = Organization.first

        authorize! @organization
      end
    end
  end
end
