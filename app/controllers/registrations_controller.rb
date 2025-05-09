class RegistrationsController < Devise::RegistrationsController
  include OrganizationScopable
  layout :set_layout, only: [:edit, :update, :new]

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
        # TODO Currently a person shouldn't exist without a user with the same email. If the person exists (but no user),
        # how should we be handling this newly created user?
        unless Person.exists?(email: resource.email)
          person = Person.create!(user_id: resource.id, first_name: resource.first_name, last_name: resource.last_name, email: resource.email)
          person.add_group(:adopter)
        end
      end
    end
  end

  def update_resource(resource, params)
    if resource.google_oauth_user?
      params.delete("current_password")
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  private

  def set_layout
    if allowed_to?(:index?, with: Organizations::DashboardPolicy, context: {person: Current.person})
      "dashboard"
    elsif allowed_to?(:index?, with: Organizations::AdopterFosterDashboardPolicy, context: {person: Current.person})
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
    # people query is scoped via acts_as_tenant and will only
    # return the single person the user has in the current org
    person = resource.people.first

    if person&.staff_active?
      staff_dashboard_index_path
    elsif person&.active_in_group?(:adopter) || person&.active_in_group?(:fosterer)
      adopter_fosterer_dashboard_index_path
    else
      root_path
    end
  end

  def after_sign_up_path_for(resource)
    return root_path unless allowed_to?(:index?, with: Organizations::AdopterFosterDashboardPolicy, context: {person: Current.person})

    if Current.organization.external_form_url
      adopter_fosterer_external_form_index_path
    else
      adopter_fosterer_dashboard_index_path
    end
  end

  # check for id (i.e., record saved) and send mail
  def send_email
    return unless resource.id

    SignUpMailer.with(user: resource).adopter_welcome_email(current_tenant).deliver_now
  end
end

# see here for setting up redirects after login for each user type
# https://stackoverflow.com/questions/58296569/how-to-signup-in-two-different-pages-with-devise
