class RegistrationsController < Devise::RegistrationsController
  include OrganizationScopable
  layout :set_layout, only: %i[edit update new create]
  after_action :send_email, only: :create

  # nested form in User>registration>new for an adopter or staff account
  # no attributes need to be accepted, just create new account with user_id reference
  def new
    build_resource({})
    respond_with resource
  end

  # MARK: only adopters are created through this route.
  def create
    super do |resource|
      if resource.persisted?
        # TODO: Currently a person shouldn't exist without a user with the same email. If the person exists (but no user),
        # how should we be handling this newly created user?
        unless Person.exists?(email: resource.email)
          @person = resource.people.create!(
            person_params.merge(email: resource.email)
          ).tap { |p| p.add_group(:adopter) }
        end
      end
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :email, :password, :password_confirmation, :tos_agreement,
      person: [:first_name, :last_name]
    ])
  end

  def update_resource(resource, params)
    # Handle person attributes separately
    if params[:person].present? && Current.person
      Current.person.update(person_params)
    end

    # Update user with password if provided, without password if not
    if params[:password].present?
      resource.update_with_password(params.except(:person))
    else
      resource.update_without_password(params.except(:person, :current_password))
    end
  end

  private

  def person_params
    # Person params are nested under user params in the form
    if params[:user] && params[:user][:person]
      params[:user].require(:person).permit(:first_name, :last_name)
    else
      params.require(:person).permit(:first_name, :last_name)
    end
  end

  def set_layout
    if allowed_to?(:index?, with: Organizations::DashboardPolicy)
      "dashboard"
    elsif allowed_to?(:index?, with: Organizations::AdopterFosterDashboardPolicy)
      "adopter_foster_dashboard"
    else
      "application"
    end
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :tos_agreement)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :avatar)
  end

  def after_update_path_for(_resource)
    if Current.person&.staff_active?
      staff_dashboard_index_path
    elsif Current.person&.active_in_group?(:adopter) || Current.person&.active_in_group?(:fosterer)
      adopter_fosterer_dashboard_index_path
    else
      root_path
    end
  end

  def after_sign_up_path_for(resource)
    # Devise sets `current_user` only after this callback runs, so we
    # must explicitly call it here
    set_current_person

    return root_path unless allowed_to?(:index?, with: Organizations::AdopterFosterDashboardPolicy)

    new_person_after_sign_up_path
  end

  def send_email
    SignUpMailer.with(person: @person).adopter_welcome_email.deliver_now
  end
end
