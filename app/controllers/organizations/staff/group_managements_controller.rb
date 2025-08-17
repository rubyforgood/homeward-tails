module Organizations
  module Staff
    class GroupManagementsController < Organizations::BaseController
      before_action :set_person, only: %i[create update]

      def create
        group = params[:group]&.to_sym

        authorize! @person, with: GroupManagementPolicy, context: {group: group}
        @person.add_group(group)

        redirect_to staff_people_path, notice: "#{group.to_s.titleize} group added."
      end

      def update
      end

      private

      def set_person
        @person = Person.find(params[:person_id])
      end
    end
  end
end
