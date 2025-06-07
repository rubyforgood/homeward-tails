require "test_helper"

class Users::OmniauthCallbacksTest < ActionDispatch::IntegrationTest
  setup do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: "google_oauth2",
      uid: "123456789",
      info: {
        email: "test@example.com",
        name: "Test User",
        first_name: "Test",
        last_name: "User"
      },
      credentials: {
        token: "token123",
        refresh_token: "refresh123",
        expires_at: Time.now + 1.week
      }
    })
  end

  teardown do
    OmniAuth.config.test_mode = false
  end

  test "should create new user from google oauth" do
    assert_difference "User.count", 1 do
      post user_google_oauth2_omniauth_callback_path
      assert_response :redirect
      assert_redirected_to edit_tos_agreement_path
    end

    user = User.last
    assert_equal "test@example.com", user.email
    assert_equal "google_oauth2", user.provider
    assert_equal "123456789", user.uid

    person = Person.last
    assert_equal "Test", person.first_name
    assert_equal "User", person.last_name
    assert_equal user.id, person.user_id
    assert_equal "test@example.com", person.email
  end

  test "should sign in existing user from google oauth" do
    user = User.create!(
      email: "test@example.com",
      provider: "google_oauth2",
      uid: "123456789",
      password: Devise.friendly_token[0, 20]
    )
    Person.create!(
      user: user,
      email: user.email,
      first_name: "Test",
      last_name: "User",
      organization: ActsAsTenant.current_tenant
    )

    assert_no_difference "User.count" do
      assert_no_difference "Person.count" do
        post user_google_oauth2_omniauth_callback_path
        assert_response :redirect
      end
    end

    assert_equal user.id, User.last.id
  end

  test "should handle authentication failure" do
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials

    post user_google_oauth2_omniauth_callback_path
    assert_response :redirect
    assert_redirected_to root_path
  end
end
