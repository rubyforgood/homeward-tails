require "test_helper"

class Organization::EditTest < ActionDispatch::IntegrationTest
  setup do
    @org = ActsAsTenant.current_tenant
    super_admin = create(:person, :super_admin).user
    sign_in super_admin
    get edit_staff_organization_path(@org)
  end

  test "all expected fields are present on the edit organization page" do
    assert_select "label", text: "Phone number"
    assert_select "input[name='organization[phone_number]'][type='tel']"

    assert_select "label", text: "Email"
    assert_select "input[name='organization[email]'][type='text']"

    assert_select "label", text: "Country"
    assert_select "select[name='organization[locations_attributes][0][province_state]']"

    assert_select "label", text: "City/Town"
    assert_select "input[name='organization[locations_attributes][0][city_town]'][type='text']"

    assert_select "label", text: "Attach logo"
    assert_select "input[name='organization[avatar]']"

    assert_select 'input[type="submit"][value="Save profile"]'
  end

  test "organization updates with the submission of the form" do
    patch staff_organization_path(@org), params: {
      organization: {
        email: "happy_paws_rescue@gmail.com",
        phone_number: "3038947563",
        locations_attributes: {
          "0" => {
            country: "US",
            province_state: "CO",
            city_town: "Golden"
          }
        },
        facebook_url: "https://example.com",
        instagram_url: "https://example.com",
        donation_url: "https://example.com",
        avatar: fixture_file_upload("/logo.png")
      }
    }
    @org.reload

    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert_equal "happy_paws_rescue@gmail.com", @org.email
    assert_equal "+13038947563", @org.phone_number
    assert_equal "US", @org.locations.last.country
    assert_equal "CO", @org.locations.last.province_state
    assert_equal "Golden", @org.locations.last.city_town
    assert_equal "logo.png", @org.avatar.filename.sanitized
    assert_equal "https://example.com", @org.facebook_url
    assert_equal "https://example.com", @org.instagram_url
    assert_equal "https://example.com", @org.donation_url
  end

  test "organization updates with only some form fields to update" do
    patch staff_organization_path(@org), params: {
      organization: {
        phone_number: "3038947542",
        donation_url: "https://example.com"
      }
    }
    @org.reload

    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert_equal "+13038947542", @org.phone_number
    assert_equal "https://example.com", @org.donation_url
  end

  test "organization does not update with a non valid phone number" do
    patch staff_organization_path(@org), params: {
      organization: {
        phone_number: "303894754232849320"
      }
    }
    @org.reload
    assert_response :unprocessable_entity
    assert_select "div.alert.alert-danger.mt-1", text: "Please fix the errors highlighted below."
  end

  test "organization does not update with an invalid email" do
    patch staff_organization_path(@org), params: {
      organization: {
        email: "happy_pets_bad_email.com"
      }
    }
    @org.reload
    assert_response :unprocessable_entity
    assert_select "div.alert.alert-danger.mt-1", text: "Please fix the errors highlighted below."
  end

  test "organization does not update with an invalid url" do
    patch staff_organization_path(@org), params: {
      organization: {
        facebook_url: "not a url"
      }
    }
    @org.reload
    assert_response :unprocessable_entity
    assert_select "div.alert.alert-danger.mt-1", text: "Please fix the errors highlighted below."
  end
end
