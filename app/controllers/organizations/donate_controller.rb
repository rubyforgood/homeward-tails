module Organizations
  class DonateController < Organizations::BaseController
    skip_before_action :authenticate_user!
    skip_verify_authorized only: %i[index]
    def index
    end
  end
end
