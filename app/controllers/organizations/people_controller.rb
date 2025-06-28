module Organizations
  class PeopleController < Organizations::BaseController
    skip_before_action :verify_person_in_org
    skip_verify_authorized only: %i[new create]
    before_action :validate_person_does_not_exist, only: %i[new create]

    def index
      authorize!
      @people = Person.all
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

    private

    def validate_person_does_not_exist
      set_current_person

      if Current.person.present?
        flash[:notice] = t(".already_member")
        redirect_to adopter_fosterer_dashboard_index_path
      end
    end

    def person_params
      params.require(:person).permit(:email, :first_name, :last_name, :user_id)
    end
  end
end
