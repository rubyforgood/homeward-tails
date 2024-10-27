# class to create a new location, organization, user, and staff account with role admin
# email is sent to admin user if all steps are successful
# call with Organizations::CreateService.new.signal(args)
# sample args:
# {
#   location: {
#     country: 'Mexico',
#     city_town: 'La Ventana',
#     province_state: 'Baja'
#   },
#   organization: {
#     name: 'Baja Pet Rescue',
#     slug: 'baja'
#   },
#   user: {
#     email: 'test@test.lol',
#     first_name: 'Jimmy',
#     last_name: 'Hendrix'
#   }
# }

class Organizations::CreateService
  def signal(args)
    ActiveRecord::Base.transaction do
      create_organization(
        args[:organization][:name],
        args[:organization][:slug],
        args[:organization][:email]
      )
      create_user(
        args[:user][:email],
        args[:user][:first_name],
        args[:user][:last_name]
      )
      add_super_admin_role_to_user
      send_email
      create_custom_page
    end
  rescue => e
    raise "An error occurred: #{e.message}"
  end

  private

  def create_organization(name, slug, email)
    @organization = Organization.create!(
      name: name,
      slug: slug,
      email: email
    )
  end

  def create_user(email, first_name, last_name)
    ActsAsTenant.with_tenant(@organization) do
      @user = User.create!(
        email: email,
        first_name: first_name,
        last_name: last_name,
        password: SecureRandom.hex(3)[0, 6],
        tos_agreement: 1
      )
    end
  end

  def add_super_admin_role_to_user
    @user.add_role(:super_admin, @organization)

    if !@user.has_role?(:super_admin, @organization)
      raise StandardError, "Failed to add super admin role"
    end
  end

  def send_email
    OrganizationMailer.with(
      user: @user,
      organization: @organization
    )
      .create_new_org_and_admin(@organization.slug).deliver_now
  end

  def create_custom_page
    ActsAsTenant.with_tenant(@organization) do
      CustomPage.create!
    end
  end
end
