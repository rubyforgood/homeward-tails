require "test_helper"

class Organizations::CreateServiceTest < ActiveSupport::TestCase
  test "it creates location and custom_page when organization is created" do
    args = {
      location: {
        country: "Mexico",
        city_town: "La Ventana",
        province_state: "Baja"
      },
      organization: {
        name: "Baja Pet Rescue",
        slug: "baja",
        email: "baja@email.com"
      },
      user: {
        email: "test@test.lol",
        first_name: "Jimmy",
        last_name: "Hendrix"
      }
    }

    Organizations::CreateService.any_instance.stubs(:send_email).returns(true)

    assert_difference "Organization.count", 1 do
      Organizations::CreateService.new.signal(args)

      organization = Organization.last

      location = organization.locations.last
      assert_not_nil location, "Location was not created"
      assert_equal "Mexico", location.country
      assert_equal "La Ventana", location.city_town
      assert_equal "Baja", location.province_state
      
      custom_page = organization.custom_page
      assert_not_nil custom_page, "Custom page was not created"
    end
  end
end
