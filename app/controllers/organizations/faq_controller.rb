class Organizations::FaqController < Organizations::BaseController
  skip_before_action :authenticate_user!
  skip_verify_authorized only: %i[index]

  def index
    @faqs = Faq.all
  end
end
