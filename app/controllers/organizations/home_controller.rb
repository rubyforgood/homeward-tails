class Organizations::HomeController < Organizations::BaseController
  skip_before_action :authenticate_user!
  skip_verify_authorized only: %i[index]

  def index
    @pets = Pet.with_photo
      .unadopted
      .includes(images_attachments: :blob)
      .sample(4)

    @unique_species = Pet.unique_species
  end
end
