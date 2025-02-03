module Organizations
  module AdopterFosterer
    class TaskPolicy < Organizations::ApplicationPolicy
      def index?
        permission?(:read_pet_tasks)
      end
    end
  end
end
