module Organizations
  module Staff
    # This controller is meant to be used in conjunction with the devise InvitationsController.
    class FostererInvitationsController < Organizations::BaseController
      layout "dashboard", only: %i[new]

      def new
        authorize! User,
          with: Organizations::FostererInvitationPolicy

        @user = User.new
        @person = Person.new
        @person.build_location
      end
    end
  end
end
