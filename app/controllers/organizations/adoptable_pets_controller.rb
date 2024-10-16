class Organizations::AdoptablePetsController < Organizations::BaseController
  include ::Pagy::Backend

  skip_before_action :authenticate_user!
  skip_verify_authorized only: %i[index]
  before_action :set_likes, only: %i[index show],
    if: -> { allowed_to?(:index?, Like) }
  helper_method :get_animals

  def index
    params.compact_blank!
    species = case params[:species]
    when "dog"
      Pet.Dog.unadopted
    when "cat"
      Pet.Cat.unadopted
    else
      Pet.unadopted
    end

    @q = authorized_scope(species, with: Organizations::AdoptablePetPolicy).ransack(params[:q])
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

  def get_animals
    Pet.species.keys.to_h do |s|
      [s, authorized_scope(Pet.where(species: s).distinct.order(:breed), with: Organizations::AdoptablePetPolicy).pluck(:breed)]
    end
  end

  def set_likes
    likes = current_user.person.likes
    @likes_by_id = likes.index_by(&:pet_id)
  end
end
