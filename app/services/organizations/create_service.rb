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
#     password: 'password123'
#   },
#   person: {
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
        args[:user][:password]
      )
      create_person(
        args[:person][:first_name],
        args[:person][:last_name]
      )
      add_super_admin_group_to_person
      send_email
      create_custom_page

      {organization: @organization, user: @user, person: @person}
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

  def create_user(email, password = nil)
    @user = User.create!(
      email: email,
      password: SecureRandom.hex(3)[0, 6]
    )
  end

  def create_person(first_name, last_name)
    ActsAsTenant.with_tenant(@organization) do
      @person = Person.create!(
        user: @user,
        first_name: first_name,
        last_name: last_name,
        email: @user.email
      )
    end
  end

  def add_super_admin_group_to_person
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
      if @organization.respond_to?(:create_custom_page!)
        @organization.create_custom_page!
      elsif @organization.respond_to?(:custom_page)
        @organization.build_custom_page.save!
      else
        CustomPage.create!
      end
    end
  rescue => e
    Rails.logger.error "Failed to create CustomPage: #{e.message}"
    raise e
  end
end
