class RegistrationsController < Devise::RegistrationsController
  include OrganizationScopable
  layout :set_layout, only: %i[edit update new create]
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  after_action :send_email, only: :create

  # nested form in User>registration>new for an adopter or staff account
  # no attributes need to be accepted, just create new account with user_id reference
  def new
    build_resource({})
    respond_with resource
  end

  # MARK: only adopters are created through this route.
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      # Create person record with name information
      create_person_for_user(resource)

      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_up!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :email, :password, :password_confirmation
    ])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :email, :password, :password_confirmation, :current_password
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

  def create_person_for_user(user)
    if params[:person].present?
      person = Person.create!(
        user: user,
        email: user.email,
        first_name: params[:person][:first_name] || "",
        last_name: params[:person][:last_name] || "",
        phone_number: params[:person][:phone_number]
      )
      # Add adopter role to new registrations
      person.add_group(:adopter)
      person
    end
  end

  def person_params
    params.require(:person).permit(:first_name, :last_name, :phone_number)
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
    params.require(:user).permit(:username,
      :first_name,
      :last_name,
      :email,
      :password,
      :signup_role,
      :tos_agreement,
      adopter_foster_account_attributes: [:user_id])
  end

  def account_update_params
    params.require(:user).permit(:username,
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation,
      :signup_role,
      :current_password,
      :avatar)
  end

  def after_update_path_for(resource)
    if Current.person&.staff?
      staff_dashboard_index_path
    else
      adopter_fosterer_dashboard_index_path
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
    SignUpMailer.with(
      user: resource,
      person: @person,
      organization: Current.organization
    ).adopter_welcome_email.deliver_now
  end
end

# see here for setting up redirects after login for each user type
# https://stackoverflow.com/questions/58296569/how-to-signup-in-two-different-pages-with-devise
