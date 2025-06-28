module Organizations
  module Staff
    class CustomPagesController < Organizations::BaseController
      layout "dashboard"
      before_action :set_custom_page, only: %i[edit update]
      before_action :example_pet, only: %i[edit]

      def edit
      end

      def update
        if @custom_page.update(custom_page_params)
          redirect_to edit_staff_custom_page_path, notice: t(".success")
        else
          redirect_to edit_staff_custom_page_path, alert: @custom_page.errors.full_messages.to_sentence
        end
      end

      private

      def custom_page_params
        params.require(:custom_page).permit(:hero, :about, :hero_image, :adoptable_pet_info, about_us_images: [])
      end

      def set_custom_page
        @custom_page = CustomPage.first
        authorize! @custom_page
      end

      def example_pet
        @example_pet ||= Pet.unadopted.first
      end
    end
  end
end
