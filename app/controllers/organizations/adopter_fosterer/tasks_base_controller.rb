module Organizations
  module AdopterFosterer
    class TasksBaseController < Organizations::BaseController
      before_action :context_authorize!
      before_action :set_pet

      def index
        @tasks = @pet.tasks.is_not_completed
      end

      private

      def set_pet
        @pet = Pet.find(params[:pet_id])
      end

      def context_authorize!
        authorize! with: Organizations::AdopterFosterer::TaskPolicy
      end
    end
  end
end
