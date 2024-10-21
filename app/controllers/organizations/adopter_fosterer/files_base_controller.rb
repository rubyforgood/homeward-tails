module Organizations
  module AdopterFosterer
    class FilesBaseController < Organizations::BaseController
      skip_verify_authorized only: %i[index]

      def index
        @pet = Pet.find(params[:pet_id])
      end
    end
  end
end
