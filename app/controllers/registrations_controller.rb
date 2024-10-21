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

  # MARK: only adopters are created through this route. Adopters need both the adoper role and a form submission to attach their applications to
  def create
    super do |resource|
      if resource.persisted?
        resource.add_role(:adopter, Current.organization)
        resource.person.form_submissions.create
      end
    end
  end

  private

  def set_layout
    if allowed_to?(:index?, with: Organizations::DashboardPolicy, context: {organization: Current.organization})
      "dashboard"
    elsif allowed_to?(:index?, with: Organizations::AdopterFosterDashboardPolicy, context: {organization: Current.organization})
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

  def after_sign_up_path_for(resource)
    return root_path unless allowed_to?(:index?, with: Organizations::AdopterFosterDashboardPolicy, context: {organization: Current.organization})

    if Current.organization.external_form_url
      adopter_fosterer_external_form_index_path
    else
      adopter_fosterer_dashboard_index_path
    end
  end

  # check for id (i.e., record saved) and send mail
  def send_email
    return unless resource.id

    SignUpMailer.with(user: resource).adopter_welcome_email(current_tenant.slug).deliver_now
  end
end

# see here for setting up redirects after login for each user type
# https://stackoverflow.com/questions/58296569/how-to-signup-in-two-different-pages-with-devise
