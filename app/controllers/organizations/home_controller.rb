class Organizations::HomeController < Organizations::BaseController
  skip_before_action :authenticate_user!
  skip_verify_authorized only: %i[index]

  def index
    @pets = Pet.with_photo
      .unadopted
      .includes(images_attachments: :blob)
      .sample(4)

    @adoptable_unique_species = Pet.adoptable_unique_species
  end
end
