module Organizations
  module Staff
    class InvitationsController < Devise::InvitationsController
      include OrganizationScopable

      layout "dashboard", only: [:new, :create]

      before_action :configure_permitted_parameters, if: :devise_controller?

      # This action is for generally creating any User, and it is currently unused.
      # See the other sub InvitationsControllers for the used `new` actions.
      def new
        raise NotImplementedError, "Do not use the 'new' action in Staff::InvitationsController."
      end

      def create
        # We have different return paths based on the roles provided in the params.
        # If you extend this, make sure new paths have their own authz!
        case user_params[:roles]
        when "super_admin", "admin"
          authorize! User,
            with: Organizations::StaffInvitationPolicy

          # User may already exist as adopter, fosterer, or staff for another
          # organization and there needs to be a way to invite them as staff
          # for this organization.
          # TODO: The user should probably get an email letting them know they
          # were added to a new organization.
          @user = User.find_by(email: user_params[:email])

          if @user.nil?
            @user = User.new(
              user_params.merge(password: SecureRandom.hex(8)).except(:roles)
            )
            if @user.save
              @user.invite!(current_user)
            else
              render "organizations/staff/staff_invitations/new", status: :unprocessable_entity
            end
          end

          @person = set_person

          if @person.staff?
            redirect_to staff_staff_index_path, notice: "User is already Staff in this organization"
          else
            @person.add_group(user_params[:roles])
            # TODO send notice to email
            redirect_to staff_staff_index_path, notice: t(".success")

          end

        when "fosterer"
          # TODO unpermitted param
          authorize! User,
            with: Organizations::FostererInvitationPolicy

          @user = User.find_by(email: user_params[:email])

          if @user.nil?
            @user = User.new(
              user_params.merge(password: SecureRandom.hex(8)).except(:roles)
            )
            if @user.save
              @user.invite!(current_user)
            else
              render "organizations/staff/fosterer_invitations/new", status: :unprocessable_entity
            end
          end

          @person = set_person
          @person.add_group(:adopter, :fosterer)

          redirect_to staff_fosterers_path, notice: t(".success")
        else
          authorize! User,
            with: Organizations::InvitationPolicy

          redirect_back_or_to root_path
        end
      end

      private

      def user_params
        params.require(:user)
          .permit(
            :first_name, :last_name, :email, :roles,
            person_attributes: [
              :phone_number,
              location_attributes: %i[country province_state city_town]
            ]
          )
      end

      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[tos_agreement])
      end

      def after_accept_path_for(_resource)
        # Devise sets `current_user` only after this callback runs, so we
        # must explicitly call it here
        set_current_person

        if allowed_to?(
          :index?, with: Organizations::DashboardPolicy
        )
          staff_dashboard_index_path
        elsif allowed_to?(
          :index?, with: Organizations::AdopterFosterDashboardPolicy
        )
          adopter_fosterer_dashboard_index_path
        else
          root_path
        end
      end

      def create_person(user)
        # TODO do we need this condition?
        unless Person.exists?(email: user.email)
          Person.create!(user_id: user.id, first_name: user.first_name, last_name: user.last_name, email: user.email)
        end
      end

      def set_person
        @person ||= @user.people.first || create_person(@user)
      end
    end
  end
end
