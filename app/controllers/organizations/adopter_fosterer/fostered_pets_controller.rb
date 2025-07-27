module Organizations
  module AdopterFosterer
    class FosteredPetsController < Organizations::BaseController
      before_action :context_authorize!
      layout "adopter_foster_dashboard"

      def index
        @fostered_pets = authorized_scope(Match.fosters.current.or(Match.fosters.upcoming), with: Organizations::AdopterFosterer::MatchPolicy, context: {type: "foster"})
      end

      private

      def context_authorize!
        authorize! with: Organizations::AdopterFosterer::MatchPolicy, context: {type: "foster"}
      end
    end
  end
end
