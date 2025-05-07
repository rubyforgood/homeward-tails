module Organizations
  module Staff
    # This controller is meant to be used in conjunction with the devise InvitationsController.
    class StaffInvitationsController < Organizations::BaseController
      layout "dashboard", only: %i[new]

      def new
        authorize! User,
          with: Organizations::StaffInvitationPolicy

        @user = User.new
      end
    end
  end
end
