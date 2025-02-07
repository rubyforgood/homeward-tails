module Organizations
  module AdopterFosterer
    class TaskPolicy < ApplicationPolicy
      def index?
        permission?(:read_pet_tasks)
      end
    end
  end
end
