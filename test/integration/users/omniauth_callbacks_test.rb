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
  end

  test "should sign in existing user from google oauth" do
    assert_difference "User.count", 1 do
      post user_google_oauth2_omniauth_callback_path
      assert_response :redirect
      assert_redirected_to edit_tos_agreement_path
    end
  end

  test "should handle authentication failure" do
    original_logger = OmniAuth.config.logger
    OmniAuth.config.logger = Logger.new(nil) # silence the logger for this test

    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials

    post user_google_oauth2_omniauth_callback_path
    assert_response :redirect
    assert_redirected_to root_path
  ensure
    OmniAuth.config.logger = original_logger
  end
end
