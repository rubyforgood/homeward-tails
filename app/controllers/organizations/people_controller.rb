module Organizations
  class PeopleController < Organizations::BaseController
    skip_verify_authorized only: %i[new create]
    before_action :validate_person_does_not_exist

    def new
      @person = Person.new
    end

    def create
      @person = Person.new(person_params)
      if @person.save
        @person.add_group(:adopter)
        redirect_to adopter_fosterer_dashboard_index_path, notice: "You have successfully joined the organization."
      else
        flash.now[:alert] = "There was an unexpected error. Please try again soon."
        render :new
      end
    end

    private

    def validate_person_does_not_exist
      if Current.person.present?
        flash[:notice] = "You are already a member of this organization."
        redirect_to adopter_fosterer_dashboard_index_path
      end
    end

    def person_params
      params.require(:person).permit(:email, :first_name, :last_name, :phone_number, :user_id)
    end
  end
end
