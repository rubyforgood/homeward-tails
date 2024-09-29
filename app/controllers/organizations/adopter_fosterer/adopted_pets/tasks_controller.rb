module Organizations
  module AdopterFosterer
    module AdoptedPets
      class TasksController < Organizations::BaseController
        before_action :context_authorize!

        def index
          @pet = Pet.find(params[:adopted_pet_id])
          @tasks = @pet.tasks.is_not_completed
        end

        private

        def context_authorize!
          authorize! with: Organizations::AdopterFosterer::TaskPolicy
        end
      end
    end
  end
end
