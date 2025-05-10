# Class to create a new location, organization, user, and staff account with role admin.
# Be sure to add the callback URL for the new org in for Google OAuth dev account
# An email is sent to admin user if all steps are successful.
# Be sure to use the Country and State codes from countries_states.yml
# call with Organizations::CreateService.new.signal(args)
# sample args:
# {
#   location: {
#     country: 'MX',
#     city_town: 'JAL',
#     province_state: 'Baja'
#   },
#   organization: {
#     name: 'Baja Pet Rescue',
#     slug: 'baja',
#     email: "lol@test.lol"
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
      create_location(
        args[:location][:country],
        args[:location][:city_town],
        args[:location][:province_state]
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

  def create_location(country, city_town, province_state)
    Location.create!(
      country: country,
      city_town: city_town,
      province_state: province_state,
      locatable: @organization
    )
  end

  def create_user(email, first_name, last_name)
    ActsAsTenant.with_tenant(@organization) do
      @user = User.create!(
        email: email,
        first_name: first_name,
        last_name: last_name,
        password: SecureRandom.hex(3)[0, 6]
      )

      @person = Person.create!(
        user: @user,
        first_name: first_name,
        last_name: last_name,
        email: email
      )
    end
  end

  def add_super_admin_role_to_user
    ActsAsTenant.with_tenant(@organization) do
      @person.add_group(:super_admin)
      unless @person.active_in_group?(:super_admin)
        raise StandardError, "Failed to add super admin role"
      end
    end
  end

  def send_email
    OrganizationMailer.with(
      user: @user,
      organization: @organization
    )
      .create_new_org_and_admin.deliver_now
  end

  def create_custom_page
    ActsAsTenant.with_tenant(@organization) do
      CustomPage.create!
    end
  end
end
