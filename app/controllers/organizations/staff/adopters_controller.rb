class Organizations::Staff::AdoptersController < Organizations::BaseController
  layout "dashboard"
  include ::Pagy::Backend

  def index
    authorize! Person, context: {organization: Current.organization}

    @q = authorized_scope(Person.adopters.includes(person_groups: :group)).ransack(params[:q])
    @pagy, @adopter_accounts = pagy(
      @q.result,
      limit: 10
    )
    @group_id = Group.find_by(name: "adopter").id
  end
end
