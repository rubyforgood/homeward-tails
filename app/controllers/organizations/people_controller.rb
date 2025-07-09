module Organizations
  class PeopleController < Organizations::BaseController
    layout "dashboard", only: %i[index show]
    include ::Pagy::Backend

    skip_before_action :verify_person_in_org, only: %i[new create]
    skip_verify_authorized only: %i[new create]
    before_action :validate_person_does_not_exist, only: %i[new create]
    before_action :set_person, only: %i[show edit update]

    def index
      authorize!

      @q = authorized_scope(Person.all).ransack(params[:q])
      @pagy, @people = pagy(
        @q.result,
        limit: 10
      )
    end

    def show
      authorize! @person
    end

    def new
      @person = Person.new
    end

    def create
      @person = Person.new(person_params)
      if @person.save
        @person.add_group(:adopter)
        redirect_to new_person_after_sign_up_path, notice: t(".success")
      else
        flash.now[:alert] = t(".error")
        render :new
      end
    end

    def edit
      edit_name = request.headers["Turbo-Frame"]&.starts_with?("full_name")
      authorize! @person, context: {edit_name: edit_name}

      @location = @person.location || @person.build_location
    end

    def update
      edit_name = person_params.key?(:first_name) || person_params.key?(:last_name)
      authorize! @person, context: {edit_name: edit_name}

      if @person.update(person_params)
        render partial: "organizations/people/details", locals: {person: @person}
      else
        flash.now[:alert] = @person.errors.full_messages.to_sentence
        render turbo_stream: turbo_stream.replace("flash", partial: "layouts/shared/flash_messages")
      end
    end

    private

    def validate_person_does_not_exist
      set_current_person

      if Current.person.present?
        flash[:notice] = t(".already_member")
        redirect_to adopter_fosterer_dashboard_index_path
      end
    end

    def set_person
      @person = Person.find(params[:id])
    end

    def person_params
      params.expect(person: [:email, :first_name, :last_name, :user_id, :phone_number, location_attributes: [:id, :city_town, :province_state, :country]])
    end
  end
end
