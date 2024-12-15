module Organizations
  class AdoptablePetsController < Organizations::BaseController
    include ::Pagy::Backend

    skip_before_action :authenticate_user!
    skip_verify_authorized only: %i[index show]
    before_action :set_likes, only: %i[index show],
      if: -> { allowed_to?(:index?, Like) }
    before_action :set_species, only: %i[index]
    before_action :set_pet, only: %i[show]

    def index
      @q =
        case @species
        when "dog"
          Pet.Dog.unadopted.published
        when "cat"
          Pet.Cat.unadopted.published
        end
          .ransack(params[:q])

      @pagy, paginated_adoptable_pets = pagy(
        @q.result.includes(:adopter_applications, :matches, images_attachments: :blob),
        limit: 9
      )

      @pets = paginated_adoptable_pets
    end

    def show
      @adoptable_pet_info = CustomPage.first&.adoptable_pet_info

      if current_user
        @adoption_application =
          AdopterApplication.find_by(
            pet_id: @pet.id,
            person_id: current_user.person.id
          ) ||
          @pet.adopter_applications.build(
            person: current_user.person
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

      redirect_back_or_to root_path if @species.nil?
    end

    def set_pet
      @pet = Pet.find(params[:id])

      redirect_back_or_to root_path if @pet.is_adopted? || !@pet.published?
    end
  end
end
