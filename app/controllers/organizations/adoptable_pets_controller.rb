module Organizations
  class AdoptablePetsController < Organizations::BaseController
    include ::Pagy::Backend

    skip_before_action :authenticate_user!
    skip_verify_authorized only: %i[index]
    before_action :set_likes, only: %i[index show],
      if: -> { allowed_to?(:index?, Like) }
    before_action :set_species, only: %i[index]

    def index
      @q = authorized_scope(
        case @species
        when "dog"
          Pet.Dog.unadopted
        when "cat"
          Pet.Cat.unadopted
        else
          redirect_back_or_to root_path and return
        end,
        with: Organizations::AdoptablePetPolicy
      ).ransack(params[:q])

      @pagy, paginated_adoptable_pets = pagy(
        @q.result.includes(:adopter_applications, :matches, images_attachments: :blob),
        limit: 9
      )

      @pets = paginated_adoptable_pets
    end

    def show
      @adoptable_pet_info = CustomPage.first&.adoptable_pet_info
      @pet = Pet.find(params[:id])
      authorize! @pet, with: Organizations::AdoptablePetPolicy

      if current_user&.latest_form_submission
        @adoption_application =
          AdopterApplication.find_by(
            pet_id: @pet.id,
            form_submission_id: current_user.latest_form_submission.id
          ) ||
          @pet.adopter_applications.build(
            form_submission: current_user.latest_form_submission
          )
      end
    end

    private

    def set_likes
      likes = current_user.person.likes
      @likes_by_id = likes.index_by(&:pet_id)
    end

    def set_species
      @species = params[:species]
    end
  end
end
