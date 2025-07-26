module Organizations
  module AdopterFosterer
    class AdoptedPetsController < Organizations::BaseController
      before_action :context_authorize!
      layout "adopter_foster_dashboard"

      def index
        @adopted_pets = authorized_scope(Match.adoptions, with: Organizations::AdopterFosterer::MatchPolicy, context: {page: "adopted_pets"})
      end

      private

      def context_authorize!
        authorize! with: Organizations::AdopterFosterer::MatchPolicy, context: {page: "adopted_pets"}
      end
    end
  end
end
