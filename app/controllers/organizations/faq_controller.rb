class Organizations::FaqController < Organizations::BaseController
  skip_before_action :authenticate_user!
  skip_before_action :verify_and_set_current_person
  skip_verify_authorized only: %i[index]

  def index
    @faqs = Faq.all
  end
end
